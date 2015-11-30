//
//  PointContainer.swift
//  Cat
//
//  Created by 童进 on 15/11/25.
//  Copyright © 2015年 qefee. All rights reserved.
//

import UIKit
import SpriteKit

class PointContainer: SKSpriteNode {
    /// 青纹理
    let textPoint1 = SKTexture(imageNamed: "point1")
    /// 橙纹理
    let textPoint2 = SKTexture(imageNamed: "point2")
    
    // 猫
    let cat = Cat(imageNamed: "cat")
    
    // 所有移动点
    var arrPoint = [EkoPoint]()
    /// 初始点
    let startIndex = 40
    /// 当前点
    var currentIndex = 40
    /// 是否找到边缘点
    var isFind = false
    /// 每次搜索的消耗次数
    var stepNum = 0
    /// 广度优先外圈点
    var arrNext = [Int]()
    
    /// 分数节点: 显示分数
    var score = SKLabelNode(text: "0")
    /// 状态节点: 显示输赢
    var status = SKLabelNode(text: "")
    
    func onInit() {
        
        initScoreNode()
        initRestartNode()
        initStatusNode()
        initMoveableNodes()
        initCatNode()
        
        initArroundNodeIndex()
        createRandomRedNodes()
    }
    
    /**
     初始化分数节点
     */
    func initScoreNode() {
        score.name = "score"
        score.position = CGPointMake(CGFloat(score.frame.width / 2 + 20), CGFloat(self.size.height - 100))
        score.zPosition = 11
        addChild(score)
    }
    
    /**
     初始化重新开始节点
     */
    func initRestartNode() {
        let restart = SKLabelNode(text: "重新开始")
        restart.name = "restart"
        restart.position = CGPointMake(CGFloat(self.size.width - restart.frame.width / 2 - 20), CGFloat(self.size.height - 100))
        restart.zPosition = 11
        addChild(restart)
    }
    
    /**
     初始化状态节点
     */
    func initStatusNode() {
        status.name = "status"
        status.position = CGPointMake(CGFloat(self.size.width / 2), CGFloat(20))
        status.zPosition = 11
        addChild(status)
    }
    
    /**
     初始化移动节点
     */
    func initMoveableNodes() {
        let width = self.size.width / 9.5
        let size  = CGSizeMake(CGFloat(width), CGFloat(width))
        for i in 0...80 {
            let point = EkoPoint(texture: textPoint2)
            point.name = "node.\(i)"
            point.size = size
            
            let row = i/9
            let col = i%9
            
            var gap: CGFloat = 0
            if row%2 == 0 {
                gap = width / 2.0
            } else {
                gap = width
            }
            
            // 判断边缘节点
            if row == 0 || row == 8 || col == 0 || col == 8 {
                point.isEdge = true
            }
            
            let x = CGFloat(col) * width + gap
            let y = CGFloat(row) * width + 160
            
            point.position = CGPointMake(CGFloat(x), CGFloat(y))
            
            point.index = i
            point.zPosition = 10
            
            addChild(point)
            
            arrPoint.append(point)
        }
    }
    
    /**
     初始化猫节点
     */
    func initCatNode() {
        let width = self.size.width / 9.5
        let size  = CGSizeMake(CGFloat(width), CGFloat(width))
        cat.size = size
        cat.position = arrPoint[startIndex].position
        cat.zPosition = 20
        addChild(cat)
    }
    
    /**
     初始化邻近节点
     */
    func initArroundNodeIndex() {
        for p in arrPoint {
            let i                     = p.index
            let row                   = i / 9

            let leftPointIndex        = i - 1
            let rightPointIndex       = i + 1
            var leftTopPointIndex     = i + 9
            var rightTopPointIndex    = i + 10
            var leftBottomPointIndex  = i - 9
            var rightBottomPointIndex = i - 8
            
            // 偶数和奇数行的邻近节点不一样
            if row % 2 == 0 {
                leftTopPointIndex     -= 1
                rightTopPointIndex    -= 1
                leftBottomPointIndex  -= 1
                rightBottomPointIndex -= 1
            }
            
            let array = [0, 1, 2, 3, 4, 5]
            let randomArray = array.sort({ (_, _) -> Bool in
                arc4random() < arc4random()
            })
            
            print(randomArray)
            
            for i in randomArray {
                switch i {
                case 0:
                    if isSameRowIndexOk(leftPointIndex, centerPointRow: row) {
                        p.arrPoint.append(leftPointIndex)
                    }
                case 1:
                    if isSameRowIndexOk(rightPointIndex, centerPointRow: row) {
                        p.arrPoint.append(rightPointIndex)
                    }
                case 2:
                    if isTopIndexOk(leftTopPointIndex, centerPointRow: row) {
                        p.arrPoint.append(leftTopPointIndex)
                    }
                case 3:
                    if isTopIndexOk(rightTopPointIndex, centerPointRow: row) {
                        p.arrPoint.append(rightTopPointIndex)
                    }
                case 4:
                    if isBottomIndexOk(leftBottomPointIndex, centerPointRow: row) {
                        p.arrPoint.append(leftBottomPointIndex)
                    }
                case 5:
                    if isBottomIndexOk(rightBottomPointIndex, centerPointRow: row) {
                        p.arrPoint.append(rightBottomPointIndex)
                    }
                default:
                    print("do nothing")
                }
            }
        }
    }
    
    /**
     index是否正确
     
     - parameter index: index
     
     - returns: 判断结果
     */
    private func isIndexOk(index: Int) -> Bool {
        return index>=0 && index<=80
    }
    
    /**
     上方index是否正确
     
     - parameter index: index
     
     - returns: 判断结果
     */
    private func isTopIndexOk(index: Int, centerPointRow: Int) -> Bool {
        if isIndexOk(index) {
            let row = index / 9
            return row == centerPointRow + 1
        } else {
            return false
        }
    }
    
    /**
     下方index是否正确
     
     - parameter index: index
     
     - returns: 判断结果
     */
    private func isBottomIndexOk(index: Int, centerPointRow: Int) -> Bool {
        if isIndexOk(index) {
            let row = index / 9
            return row == centerPointRow - 1
        } else {
            return false
        }
    }
    
    /**
     同行index是否正确
     
     - parameter index: index
     
     - returns: 判断结果
     */
    private func isSameRowIndexOk(index: Int, centerPointRow: Int) -> Bool {
        if isIndexOk(index) {
            let row = index / 9
            return row == centerPointRow
        } else {
            return false
        }
    }
    
    /**
     创建随机红节点
     */
    private func createRandomRedNodes() {
        srandom(UInt32(time(nil)))
        for i in 0...8 {
            let r1 = random() % 9 + i * 9
//            let r2 = random() % 9 + i * 9
            
            if r1 != startIndex {
                onSetRed(r1)
            }
            // 这里注释掉可以减少难度
//            if r2 != startIndex {
//                onSetRed(r2)
//            }
        }
    }
    
    /**
     设置为红色节点
     
     - parameter index: index
     */
    private func onSetRed(index: Int) {
        let p = arrPoint[index]
        p.type = PointType.red
        p.texture = textPoint1
        
        p.userInteractionEnabled = true
    }
    
    func onGetNextPoint(index: Int) {
        onSetRed(index)
        
        let currentPoint = arrPoint[currentIndex]
        for pIndex in currentPoint.arrPoint {
            if arrPoint[pIndex].isEdge && arrPoint[pIndex].type == PointType.gray {
                cat.position = arrPoint[pIndex].position
                status.text = "失败啦"
                enableAllPoints(true)
                return
            }
        }
        
        onResetStep()
//        enableAllPoints(false)
        currentPoint.onSetLabel("0")
        currentPoint.step = 0
        
        let oldValue = Int(score.text!)!
        let newValue = oldValue + 1
        score.text = "\(newValue)"
        
        arrNext.append(currentIndex)
        
        onFind(arrNext)
        
        if !isFind {
            status.text = "你赢啦"
            enableAllPoints(true)
        }
    }
    
    private func enableAllPoints(enable: Bool) {
        for p in arrPoint {
            p.userInteractionEnabled = enable
        }
    }
    
    func onGetNexts(nextIndexs: [Int]) -> [Int] {
        let step = arrPoint[nextIndexs[0]].step + 1
        
        var tempPointIndexs = [Int]()
        
        for nextIndex in nextIndexs {
            let pointIn = arrPoint[nextIndex]
            if isFind {
                break
            } else {
                for p in pointIn.arrPoint {
                    let pointOut = arrPoint[p]
                    self.stepNum += 1
                    
//                    let point = arrPoint[p]
                    if pointOut.isEdge && pointOut.type == PointType.gray {
                        arrPoint[p].onSetLabel("end")
                        
                        isFind = true
                        onGetPrePoint(arrPoint[p])
                        break
                    } else {
                        if pointOut.type == PointType.gray
                            && pointOut.step > pointIn.step
                            && pointOut.prePointIndex == -1 {
                            pointOut.step = step
                            
                            pointOut.onSetLabel("\(step)")
                            pointOut.prePointIndex = pointIn.index
                            
//                            if arrPoint[p].index != arrPoint[nextP].prePointIndex {
                                tempPointIndexs.append(p)
//                            }
                        }
                    }
                }
            }
        }
        return tempPointIndexs
    }
    
    func onFind(arrPointIndexs: [Int]) {
        if !isFind {
            let arrNexts = onGetNexts(arrPointIndexs)
            if arrNexts.count != 0 {
                onFind(arrNexts)
            }
        }
    }
    
    func onGetPrePoint(point: EkoPoint) {
        var p2 = point.arrPoint[0]
        for p in point.arrPoint {
            if arrPoint[p].step < arrPoint[p2].step {
                p2 = p
            }
        }
        
        if arrPoint[p2].step == 0 {
            point.onSetLabel("next")
            cat.position = arrPoint[point.index].position
            self.currentIndex = point.index
        } else {
            onGetPrePoint(arrPoint[p2])
        }
    }
    
    func onResetStep() {
        arrNext = [Int]()
        isFind = false
        stepNum = 0
        for p in arrPoint {
            p.step = 99
            p.prePointIndex = -1
            p.onSetLabel("")
        }
    }
    
    /**
     重新开始游戏
     */
    func restart() {
        self.score.text = "0"
        self.status.text = ""
        self.cat.position = self.arrPoint[self.startIndex].position
        for p in self.arrPoint {
            p.type = PointType.gray
            p.texture = self.textPoint2
            p.userInteractionEnabled = false
        }
        self.currentIndex = self.startIndex
        self.createRandomRedNodes()
        self.onResetStep()
    }
}
