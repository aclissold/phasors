//
//  GameScene.swift
//  Radar
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let redColor = SKColor(red: 0xAA/0xFF, green: 0, blue: 0, alpha: 1)

    let period = NSTimeInterval(8)

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()

        let midX = CGRectGetMidX(frame), midY = CGRectGetMidY(frame)
        let width = 0.75 * min(midX, midY)

        let longLine = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: width, height: 1))
        longLine.position = CGPoint(x: midX, y: midY)
        longLine.name = "Long Line"
        longLine.anchorPoint = CGPoint(x: 0, y: 0.5)
        let rotationAction = SKAction.rotateByAngle(CGFloat(2*M_PI), duration: period)
        longLine.runAction(SKAction.repeatActionForever(rotationAction))

        let circle = SKShapeNode(circleOfRadius: 30)
        circle.name = "Circle"
        circle.position = CGPoint(x: longLine.size.width, y: 0)
        circle.strokeColor = redColor

        let shortLine = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: CGRectGetWidth(circle.frame)/2, height: 1))
        shortLine.anchorPoint = CGPoint(x: 0, y: 0.5)
        let reverseRotationAction = SKAction.rotateByAngle(CGFloat(-2*M_PI), duration: period/8)
        shortLine.runAction(SKAction.repeatActionForever(reverseRotationAction))

        let emitterNode = SKEmitterNode()
        emitterNode.position = CGPoint(x: shortLine.size.width, y: 0)
        emitterNode.particleAlphaSpeed = CGFloat(-1/period)
        emitterNode.particleBirthRate = 500
        emitterNode.particleTexture = SKTexture(imageNamed: "Circle")
        emitterNode.particleColor = redColor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = CGFloat(period)
        emitterNode.targetNode = self

        addChild(longLine)
        longLine.addChild(circle)
        circle.addChild(shortLine)
        shortLine.addChild(emitterNode)
    }

}
