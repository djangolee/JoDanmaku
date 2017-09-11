//
//  KBDanmakuYellowView.swift
//  Danmaku
//
//  Created by django on 8/3/17.
//  Copyright © 2017 django. All rights reserved.
//

import UIKit
import JoDanmaku

class JoDanmakuYellowView: JoDanmakuView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layer.borderWidth = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(JoDanmakuYellowView.onClick))
        self.addGestureRecognizer(tap)
    }
    
    func onClick() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: 250, height: 44)
    }

}
