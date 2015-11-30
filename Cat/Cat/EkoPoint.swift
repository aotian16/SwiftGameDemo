//
//  EkoPoint.swift
//  Cat
//
//  Created by 童进 on 15/11/25.
//  Copyright © 2015年 qefee. All rights reserved.
//

import UIKit
import SpriteKit

enum PointType {
    case gray
    case red
}

class EkoPoint: SKSpriteNode {
    var prePointIndex = -1
    var arrPoint      = [Int]()
    var step          = 99
    var index         = 0
    var type          = PointType.gray
    var isEdge        = false
    var label: SKLabelNode?

    func onSetLabel(text: String) {
        if let l = label {
            l.name = "\(name).label"
            l.text = text
            l.zPosition = 11
        } else {
            let l = SKLabelNode(text: text)
            l.name = "\(name).label"
            l.fontSize = 20
            l.position = CGPointMake(0, -10)
            l.userInteractionEnabled = false
            l.zPosition = 11
            addChild(l)
            
            label = l
        }
    }
}
