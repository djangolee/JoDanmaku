//
//  JoDanmakuWarehouse.swift
//  Danmaku
//
//  Created by django on 8/2/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit

internal class JoDanmakuWarehouse {
    
    // MARK: Abdou cache
    
    var registerClassItems: [String: AnyClass] = [String: AnyClass]()
    var freedomViews: [JoDanmakuView] = [JoDanmakuView]()
    var hangUpViews: [String: [JoDanmakuView]] = [String: [JoDanmakuView]]()
    var runingViews: [String: [JoDanmakuView]] = [String: [JoDanmakuView]]()
    
    func register(_ itemClass: Swift.AnyClass, forCellWithReuseIdentifier identifier: String) {
        
        guard itemClass is JoDanmakuView.Type else {
            fatalError("*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'must pass a class of kind JoDanmakuView'")
        }
        
        registerClassItems[identifier] = itemClass
    }
    
    func dequeueReusableItem(withReuseIdentifier identifier: String) -> JoDanmakuView? {
    
        guard let danmakuViewClass = registerClassItems[identifier] as? JoDanmakuView.Type else {
            return nil
        }
        
        var view: JoDanmakuView? = nil
        if var views = hangUpViews[identifier], views.count > 0 {
            view = views.removeFirst()
            hangUpViews[identifier] = views
        } else {
            view = danmakuViewClass.init()
        }
        
        guard let tempView = view else {
            return nil
        }
        
        if var views = runingViews[identifier] {
            views.append(tempView)
            runingViews[identifier] = views
        } else {
            runingViews[identifier] = [tempView]
        }
        tempView.identifier = identifier
        tempView.sizeToFit()
        return tempView;
    }
    
    func queueReusableItem(withReuseIdentifier identifier: String, danmakamuView: JoDanmakuView) {
        if var views = runingViews[identifier], let index = views.index(of: danmakamuView) {
            views.remove(at: index)
            runingViews[identifier] = views
        }
        if var views = hangUpViews[identifier] {
            views.append(danmakamuView)
            hangUpViews[identifier] = views
        } else {
            hangUpViews[identifier] = [danmakamuView]
        }
    }
    
    
    func pause() {
        runingViews.forEach { (key, value) in
            value.forEach({ (view) in
                view.pause()
            })
        }
        freedomViews.forEach { (view) in
            view.pause()
        }
    }
    
    func resume() {
        runingViews.forEach { (key, value) in
            value.forEach({ (view) in
                view.resume()
            })
        }
        freedomViews.forEach { (view) in
            view.resume()
        }
    }
    
    func clearAllItems() {
        runingViews.forEach { (key, value) in
            value.forEach({ (view) in
                self.clear(view)
            })
            runingViews[key] = [JoDanmakuView]()
        }
        hangUpViews.forEach { (key, value) in
            value.forEach({ (view) in
                self.clear(view)
            })
            hangUpViews[key] = [JoDanmakuView]()
        }
        freedomViews.forEach { (view) in
            self.clear(view)
        }
        freedomViews = [JoDanmakuView]()
    }
    
    private func clear(_ item: JoDanmakuView) {
        item.stateDelegate = nil
        item.identifier = nil
        item.layer.removeAllAnimations()
        item.removeFromSuperview()
    }
}
