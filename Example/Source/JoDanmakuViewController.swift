//
//  KBDanmakuViewController.swift
//  iOS Example
//
//  Created by django on 8/9/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit
import JoDanmaku

class KBDanmakuViewController: UIViewController, KBDanmakuControllerProtocol {
    
    var timer: Timer?
    var current: TimeInterval = 0
    
    let scenceView: UIView = UIView()
    let pauseButton = UIButton()
    let resumeButton = UIButton()
    let sendButton = UIButton()
    let clearButton = UIButton()
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        scenceView.frame = view.bounds
        view.addSubview(scenceView)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        
        NSLayoutConstraint(item: label1, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label1, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: label2, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label2, attribute: .top, relatedBy: .equal, toItem: label1, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: label3, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label3, attribute: .top, relatedBy: .equal, toItem: label2, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.black, for: .normal)
        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.setTitleColor(.black, for: .normal)
        pauseButton.addTarget(self, action: #selector(KBDanmakuViewController.fun3(_:)), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(KBDanmakuViewController.fun4(_:)), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)
        view.addSubview(resumeButton)
        NSLayoutConstraint(item: pauseButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pauseButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: resumeButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: resumeButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        sendButton.setTitle("send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.addTarget(self, action: #selector(KBDanmakuViewController.fun5(_:)), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        NSLayoutConstraint(item: sendButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        clearButton.setTitle("clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.addTarget(self, action: #selector(KBDanmakuViewController.fun7(_:)), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        NSLayoutConstraint(item: clearButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: clearButton, attribute: .bottom, relatedBy: .equal, toItem: sendButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        
        KBDanmakuController.default.register(KBDanmakuView.self, forCellWithReuseIdentifier: "items")
        KBDanmakuController.default.register(KBDanmakuRedView.self, forCellWithReuseIdentifier: "red")
        KBDanmakuController.default.register(KBDanmakuYellowView.self, forCellWithReuseIdentifier: "Yellow")
        
        KBDanmakuController.default.delegate = self
        KBDanmakuController.default.push(to: scenceView)
        timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(KBDanmakuViewController.fun), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KBDanmakuViewController.fun1(_:)), name: NSNotification.Name(rawValue: "abcd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KBDanmakuViewController.fun2(_:)), name: NSNotification.Name(rawValue: "1234"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KBDanmakuViewController.fun6(_:)), name: NSNotification.Name(rawValue: "12346"), object: nil)
    }
    
    func fun1(_ notification: NSNotification) {
        guard let object = notification.object as? [String: [KBDanmakuView]] else {
            return
        }
        let sun = object.reduce(0) { (result, value) -> Int in
            return value.value.count + result
        }
        
        label1.text = "hangUpViews: \(sun)"
    }
    
    func fun2(_ notification: NSNotification) {
        guard let object = notification.object as? [String: [KBDanmakuView]] else {
            return
        }
        
        let sun = object.reduce(0) { (result, value) -> Int in
            return value.value.count + result
        }
        
        label2.text = "runingViews: \(sun)"
    }
    
    func fun6(_ notification: NSNotification) {
        guard let object = notification.object as? [KBDanmakuView] else {
            return
        }
        
        label3.text = "freedomViews: \(object.count)"
    }
    
    func fun3(_ button: UIButton) {
        KBDanmakuController.default.pause()
    }
    
    func fun4(_ button: UIButton) {
        KBDanmakuController.default.resume()
    }
    
    func fun5(_ button: UIButton) {
        let flag: Bool = arc4random() % 2 == 0
        
        let danmakuView = flag ? KBDanmakuRedView() : KBDanmakuYellowView()
        
        let animation = CABasicAnimation(keyPath: "position")
        let y: CGFloat = CGFloat(arc4random() % UInt32(view.frame.maxY))
        let v1 = NSValue(cgPoint: CGPoint(x: view.frame.maxX, y: y))
        let v2 = NSValue(cgPoint: CGPoint(x: view.frame.minX, y: y))
        
        let v = flag ? v1 : v2
        animation.fromValue = v
        animation.toValue = v == v1 ? v2 : v1
        animation.duration = 5
        
        KBDanmakuController.default.send(danmakuView, with: animation)
    }
    
    func fun7(_ button: UIButton) {
        KBDanmakuController.default.clearAllItems()
    }
    
    func fun() {
        self.current += 0.1
        KBDanmakuController.default.updateProgress(to: self.current)
    }
    
    func danmaku(_ danmaku: KBDanmakuController, numberOfRowsInRange: Range<TimeInterval>) -> Int {
        return 20
    }
    
    func danmaku(_ danmaku: KBDanmakuController, itemForRowAt index: Int, at raneg: Range<TimeInterval>) -> KBDanmakuView {
        let r = arc4random() % 3
        let offset = TimeInterval(Float(arc4random() % 50) / 10)
        if r == 0 {
            let view = KBDanmakuController.default.dequeueReusableItem(withReuseIdentifier: "items")!
            view.layer.borderWidth = 1
            view.offset = offset
            return view
        } else if r == 1 {
            let view = KBDanmakuController.default.dequeueReusableItem(withReuseIdentifier: "red")!
            view.offset = offset
            return view
        } else {
            let view = KBDanmakuController.default.dequeueReusableItem(withReuseIdentifier: "Yellow")!
            view.offset = offset
            return view
        }
    }
    
    func danmaku(_ danmaku: KBDanmakuController, animationForRowAt index: Int, at raneg: Range<TimeInterval>, danmakuView: KBDanmakuView) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        let y: CGFloat = CGFloat(arc4random() % UInt32(view.frame.maxY))
        let v1 = NSValue(cgPoint: CGPoint(x: view.frame.maxX, y: y))
        let v2 = NSValue(cgPoint: CGPoint(x: view.frame.minX, y: y))
        
        let v = arc4random() % 2 == 0 ? v1 : v2
        animation.fromValue = v
        animation.toValue = v == v1 ? v2 : v1
        animation.duration = 5
        return animation
    }
    
}

