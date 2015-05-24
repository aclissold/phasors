//
//  GameScene.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var numberOfPhasorNodes = 2 {
        didSet {
            resetPhasorNodes()
        }
    }

    private var phasorNodes = [PhasorNode]()

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        resetPhasorNodes()
    }

    func setPeriod(period: NSTimeInterval, forPhasor phasor: Int) {
    }

    func resetPhasorNodes() {
        removeChildrenInArray(phasorNodes)
        phasorNodes.removeAll(keepCapacity: true)

        for i in 0..<numberOfPhasorNodes {
            let phasorNode = PhasorNode()
            if let lastPhasorNode = phasorNodes.last {
                phasorNode.position = CGPoint(x: CGRectGetWidth(lastPhasorNode.line.frame), y: 0)
                lastPhasorNode.line.addChild(phasorNode)
            } else {
                let midX = CGRectGetMidX(frame), midY = CGRectGetMidY(frame)
                phasorNode.position = CGPoint(x: midX, y: midY)
                addChild(phasorNode)
            }
            phasorNode.trail.targetNode = self

            if i == numberOfPhasorNodes-1 {
                phasorNode.showTrail()
            }

            phasorNodes.append(phasorNode)
        }
    }
}
