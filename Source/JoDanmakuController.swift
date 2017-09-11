//
//  JoDanmakuController.swift
//  Danmaku
//
//  Created by django on 8/2/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit

final public class JoDanmakuController: NSObject {
    
    public override init() {
        
        rate = 1
        threshold = 10
        rangeLength = 5
        currentRange = 0..<rangeLength
        
        super.init()
    }
    
    // MARK: Member variable
    
    static public let `default`: JoDanmakuController = JoDanmakuController()
    fileprivate var viewWarehouse: JoDanmakuWarehouse = JoDanmakuWarehouse()
    
    public weak var delegate: JoDanmakuControllerProtocol?
    public weak var sceneView: UIView?
    
    private (set) var rate: Float
    public var threshold: Int
    public var currentRange: Range<TimeInterval> {
        didSet { DispatchQueue.main.async { self.prepareData(range: self.currentRange) } }
    }
    public var rangeLength: TimeInterval {
        didSet { currentRange = currentRange.lowerBound..<(currentRange.lowerBound + rangeLength) }
    }
    
    // MARK: Public methods
    
    public func push(to scene: UIView, beginTime: TimeInterval = 0) {
        sceneView = scene
        currentRange = beginTime..<(beginTime + rangeLength)
    }
    
    public func send(_ danmakuView: JoDanmakuView, with anima: CAAnimation) {
        guard let sceneView = sceneView, sceneView.window != nil else { return }
        
        danmakuView.sizeToFit()
        danmakuView.identifier = nil
        danmakuView.stateDelegate = self
        danmakuView.run(superView: sceneView, animation: anima)
        rate == 1 ? danmakuView.resume() : danmakuView.pause()
        viewWarehouse.freedomViews.append(danmakuView)
    }
    
    private func prepareData(range: Range<TimeInterval>) {

        guard let delegate = delegate,
            let sceneView = sceneView,
            sceneView.window != nil,
            rate == 1 else { return }
        
        var number = delegate.danmaku(self, numberOfRowsInRange: range)
        number = number > threshold ? threshold : number
        for index in 0..<number {
            let view = delegate.danmaku(self, itemForRowAt: index, at: range)
            let animation = delegate.danmaku(self, animationForRowAt: index, at: range, danmakuView: view)
            view.stateDelegate = self
            view.run(superView: sceneView, animation: animation)
            rate == 1 ? view.resume() : view.pause()
        }
    }
    
    // MARK: Control
    
    public func updateProgress(to time: TimeInterval) {
        guard sceneView?.window != nil, rate != 0 else { return }
        guard abs(time - currentRange.lowerBound) >= rangeLength else { return }
        currentRange = time..<(time + rangeLength)
    }
    
    public func resume() {
        rate = 1
        viewWarehouse.resume()
    }
    
    public func pause() {
        rate = 0
        viewWarehouse.pause()
    }
    
    public func clearAllItems() {
        viewWarehouse.clearAllItems()
    }
}

extension JoDanmakuController: JoDanmakuViewStateProtocol {
    
    public func register(_ itemClass: Swift.AnyClass, forCellWithReuseIdentifier identifier: String) {
        viewWarehouse.register(itemClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func dequeueReusableItem(withReuseIdentifier identifier: String) -> JoDanmakuView? {
        return viewWarehouse.dequeueReusableItem(withReuseIdentifier:identifier)
    }
    
    func animationDidCompletion(danmakuView: JoDanmakuView) {
        if let index = viewWarehouse.freedomViews.index(of: danmakuView) {
            viewWarehouse.freedomViews.remove(at: index)
        }
        
        if let identifier = danmakuView.identifier {
            viewWarehouse.queueReusableItem(withReuseIdentifier: identifier, danmakamuView: danmakuView)
        }
    }
}

