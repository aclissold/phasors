//
//  GameScene.swift
//  Radar
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let period = NSTimeInterval(8)
    var phasorNodes = [PhasorNode]()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()

        let midX = CGRectGetMidX(frame), midY = CGRectGetMidY(frame)

        for _ in 0..<2 {
            addPhasorNode()
        }
    }

    func setPeriod(period: NSTimeInterval, forPhasor phasor: Int) {
    }

    func addPhasorNode() {
        let phasorNode: PhasorNode

        if count(phasorNodes) == 0 {
            let midX = CGRectGetMidX(frame), midY = CGRectGetMidY(frame)

            phasorNode = PhasorNode()
            phasorNode.position = CGPoint(x: midX, y: midY)

            addChild(phasorNode)
            phasorNodes.append(phasorNode)
        } else {
            let lastPhasor = phasorNodes.last!
            phasorNode = PhasorNode()
            phasorNode.position = CGPoint(x: CGRectGetWidth(lastPhasor.line.frame), y: 0)

            lastPhasor.line.addChild(phasorNode)
            phasorNodes.append(phasorNode)
        }

        phasorNode.trail.targetNode = self
        showLastPhasorNodeTrail()
    }

    func removePhasorNode() {
    }

    func showLastPhasorNodeTrail() {
        for phasorNode in phasorNodes {
            if phasorNode === phasorNodes.last {
                phasorNode.showTrail()
            } else {
                phasorNode.hideTrail()
            }
        }
    }

}
