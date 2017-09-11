//
//  JoViewController.swift
//  Example
//
//  Created by django on 3/2/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit
import JoDanmaku

class JoViewController: UIViewController, JoDanmakuControllerProtocol {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func fun1(_ notification: NSNotification) {
        guard let object = notification.object as? [String: [JoDanmakuView]] else {
            return
        }
        let sun = object.reduce(0) { (result, value) -> Int in
            return value.value.count + result
        }
        
        label1.text = "hangUpViews: \(sun)"
    }
    
    func fun2(_ notification: NSNotification) {
        guard let object = notification.object as? [String: [JoDanmakuView]] else {
            return
        }
        
        let sun = object.reduce(0) { (result, value) -> Int in
            return value.value.count + result
        }
        
        label2.text = "runingViews: \(sun)"
    }
    
    func fun6(_ notification: NSNotification) {
        guard let object = notification.object as? [JoDanmakuView] else {
            return
        }
        
        label3.text = "freedomViews: \(object.count)"
    }
    
    func fun3(_ button: UIButton) {
        JoDanmakuController.default.pause()
    }
    
    func fun4(_ button: UIButton) {
        JoDanmakuController.default.resume()
    }
    
    func fun5(_ button: UIButton) {
        let flag: Bool = arc4random() % 2 == 0
        
        let danmakuView = flag ? JoDanmakuRedView() : JoDanmakuYellowView()
        
        let animation = CABasicAnimation(keyPath: "position")
        let y: CGFloat = CGFloat(arc4random() % UInt32(view.frame.maxY))
        let v1 = NSValue(cgPoint: CGPoint(x: view.frame.maxX, y: y))
        let v2 = NSValue(cgPoint: CGPoint(x: view.frame.minX, y: y))
        
        let v = flag ? v1 : v2
        animation.fromValue = v
        animation.toValue = v == v1 ? v2 : v1
        animation.duration = 5
        
        JoDanmakuController.default.send(danmakuView, with: animation)
    }
    
    func fun7(_ button: UIButton) {
        JoDanmakuController.default.clearAllItems()
    }
    
    func fun() {
        self.current += 0.1
        JoDanmakuController.default.updateProgress(to: self.current)
    }
    
    func danmaku(_ danmaku: JoDanmakuController, numberOfRowsInRange: Range<TimeInterval>) -> Int {
        return 20
    }
    
    func danmaku(_ danmaku: JoDanmakuController, itemForRowAt index: Int, at raneg: Range<TimeInterval>) -> JoDanmakuView {
        let r = arc4random() % 3
        let offset = TimeInterval(Float(arc4random() % 50) / 10)
        if r == 0 {
            let view = JoDanmakuController.default.dequeueReusableItem(withReuseIdentifier: "items")!
            view.layer.borderWidth = 1
            view.offset = offset
            return view
        } else if r == 1 {
            let view = JoDanmakuController.default.dequeueReusableItem(withReuseIdentifier: "red")!
            view.offset = offset
            return view
        } else {
            let view = JoDanmakuController.default.dequeueReusableItem(withReuseIdentifier: "Yellow")!
            view.offset = offset
            return view
        }
    }
    
    func danmaku(_ danmaku: JoDanmakuController, animationForRowAt index: Int, at raneg: Range<TimeInterval>, danmakuView: JoDanmakuView) -> CAAnimation {
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

extension JoViewController {
    
    fileprivate func setupUI() {
     
        title = "Danmaku"
        
        setupLabel()
        setupButton()
        bindingLayout()
        setupDanmaku()
    }
    
    private func run() {
        timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(JoViewController.fun), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    private func setupDanmaku() {
        JoDanmakuController.default.register(JoDanmakuView.self, forCellWithReuseIdentifier: "items")
        JoDanmakuController.default.register(JoDanmakuRedView.self, forCellWithReuseIdentifier: "red")
        JoDanmakuController.default.register(JoDanmakuYellowView.self, forCellWithReuseIdentifier: "Yellow")
        
        JoDanmakuController.default.delegate = self
        JoDanmakuController.default.push(to: scenceView)
    }
    
    private func setupLabel()  {
        
        scenceView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
        view.addSubview(scenceView)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)

    }
    
    private func setupButton() {
        
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.black, for: .normal)
        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.setTitleColor(.black, for: .normal)
        pauseButton.addTarget(self, action: #selector(JoViewController.fun3(_:)), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(JoViewController.fun4(_:)), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)
        view.addSubview(resumeButton)
        
        sendButton.setTitle("send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.addTarget(self, action: #selector(JoViewController.fun5(_:)), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)

        clearButton.setTitle("clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.addTarget(self, action: #selector(JoViewController.fun7(_:)), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
    }

    private func bindingLayout() {
        
        NSLayoutConstraint(item: label1, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label1, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: label2, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label2, attribute: .top, relatedBy: .equal, toItem: label1, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: label3, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label3, attribute: .top, relatedBy: .equal, toItem: label2, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: pauseButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pauseButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: resumeButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: resumeButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sendButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: clearButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: clearButton, attribute: .bottom, relatedBy: .equal, toItem: sendButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
    }
    
    private func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(JoViewController.fun1(_:)), name: NSNotification.Name(rawValue: "abcd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JoViewController.fun2(_:)), name: NSNotification.Name(rawValue: "1234"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JoViewController.fun6(_:)), name: NSNotification.Name(rawValue: "12346"), object: nil)
    }
}
