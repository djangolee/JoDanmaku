//
//  KBDanmakuProtocol.swift
//  Danmaku
//
//  Created by django on 8/2/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit

public protocol JoDanmakuControllerProtocol: class {
 
    func danmaku(_ danmaku: JoDanmakuController, numberOfRowsInRange: Range<TimeInterval>) -> Int
    func danmaku(_ danmaku: JoDanmakuController, itemForRowAt index: Int, at raneg: Range<TimeInterval>) -> JoDanmakuView
    func danmaku(_ danmaku: JoDanmakuController, animationForRowAt index: Int, at raneg: Range<TimeInterval>, danmakuView: JoDanmakuView) -> CAAnimation

}

internal protocol JoDanmakuViewStateProtocol: class {
    
    func animationDidCompletion(danmakuView: JoDanmakuView)
    
}
