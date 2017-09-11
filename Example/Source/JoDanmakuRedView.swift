//
//  KBDanmakuRedView.swift
//  Danmaku
//
//  Created by django on 8/3/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit
import JoDanmaku

class JoDanmakuRedView: JoDanmakuView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        layer.borderWidth = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(JoDanmakuRedView.onClick))
        self.addGestureRecognizer(tap)
    }
    
    func onClick() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: 150, height: 44)
    }
    
}
