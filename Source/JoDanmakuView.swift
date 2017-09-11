//
//  JoDanmakuView.swift
//  Danmaku
//
//  Created by django on 8/2/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit

open class JoDanmakuView: UIView {
    
    // MARK: Member variable
    
    public var offset: TimeInterval = 0
    private (set) var rate: Float = 1
    
    internal var identifier: String?
    internal weak var stateDelegate: JoDanmakuViewStateProtocol?
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    
        guard let presentationLayer = layer.presentation() else {
            return super.point(inside: point, with: event)
        }
        let presentationPoint = layer.convert(point, to: presentationLayer)
        if presentationLayer.bounds.contains(presentationPoint) {
            return true
        }
        return super.point(inside: point, with: event)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
        guard let presentationLayer = layer.presentation() else {
            return super.hitTest(point, with: event)
        }
        let presentationPoint = layer.convert(point, to: presentationLayer)
        if presentationLayer.bounds.contains(presentationPoint) {
            return self;
        }
        return super.hitTest(point, with: event)
    }
    
    open override func sizeToFit() {
        frame.size = sizeThatFits(CGSize.zero)
    }
    
    public func pause() {
        if layer.speed != 0 {
            let pauseTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0
            layer.timeOffset = pauseTime
            rate = 0
        }
    }
    
    public func resume() {
        if layer.speed == 0 {
            let pauseTime = layer.timeOffset
            layer.speed = 1
            layer.timeOffset = 0
            layer.beginTime = 0
            layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
            rate = 1
        }
    }
    
}

extension JoDanmakuView: CAAnimationDelegate {
    
    private static let animationKey: String = "JoDanmakuViewAnimationKey"
    
    internal func run(superView: UIView, animation: CAAnimation) {
        layer.removeAnimation(forKey: JoDanmakuView.animationKey)
        
        animation.duration = animation.duration > 0.5 ? animation.duration : 0.5
        let keyTime = 0.25 / animation.duration
        
        let hiddenAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        hiddenAnimation.duration = animation.duration
        hiddenAnimation.values = [NSNumber(value: 0.0), NSNumber(value: 1.0), NSNumber(value: 1.0), NSNumber(value: 0.0)]
        hiddenAnimation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: keyTime), NSNumber(value: 1 - keyTime), NSNumber(value: 1.0)]
        
        let group = CAAnimationGroup()
        group.animations = [hiddenAnimation, animation]
        group.duration = animation.duration
        group.beginTime = CACurrentMediaTime() + offset
        group.delegate = self
        
        self.layer.opacity = 0
        superView.addSubview(self)
        layer.add(group, forKey: JoDanmakuView.animationKey)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stateDelegate?.animationDidCompletion(danmakuView: self)
    }
    
}
