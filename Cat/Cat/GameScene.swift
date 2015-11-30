//
//  GameScene.swift
//  Cat
//
//  Created by 童进 on 15/11/25.
//  Copyright (c) 2015年 qefee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let pointContainer = PointContainer()
    
    override func didMoveToView(view: SKView) {
        pointContainer.size = self.frame.size
        pointContainer.position = CGPointMake(0, 0)
        addChild(pointContainer)
        pointContainer.onInit()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if let t = touches.first {
            let point = t.locationInNode(self)
            
            let node = pointContainer.nodeAtPoint(point)

            if node is EkoPoint {
                let p = node as! EkoPoint
                
//                if p.type == PointType.gray {
                    pointContainer.onGetNextPoint(p.index)
//                }
            }
            if let name = node.name {
                if name == "restart" {
                    pointContainer.restart()
                }
            }
        } else {
            print("no touches error")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
