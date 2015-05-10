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

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()

        let midX = CGRectGetMidX(frame), midY = CGRectGetMidY(frame)
        let width = 0.75 * min(midX, midY)

        let longLine = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: width, height: 1))
        longLine.position = CGPoint(x: midX, y: midY)
        longLine.name = "Long Line"
        longLine.anchorPoint = CGPoint(x: 0, y: 0.5)
        let rotationAction = SKAction.rotateByAngle(CGFloat(2*M_PI), duration: NSTimeInterval(2))
        longLine.runAction(SKAction.repeatActionForever(rotationAction))

        let circle = SKShapeNode(circleOfRadius: 30)
        circle.name = "Circle"
        circle.position = CGPoint(x: longLine.size.width, y: 0)
        circle.strokeColor = redColor

        let shortLine = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: CGRectGetWidth(circle.frame)/2, height: 1))
        shortLine.anchorPoint = CGPoint(x: 0, y: 0.5)
        let reverseRotationAction = SKAction.rotateByAngle(CGFloat(-2*M_PI), duration: NSTimeInterval(0.1))
        shortLine.runAction(SKAction.repeatActionForever(reverseRotationAction))

        let emitterNode = SKEmitterNode()
        emitterNode.position = CGPoint(x: shortLine.size.width, y: 0)
        emitterNode.particleAlphaSpeed = -0.5
        emitterNode.particleBirthRate = 60
        emitterNode.particleColor = redColor
        emitterNode.particleLifetime = 2
        emitterNode.particleTexture = SKTexture(noiseWithSmoothness: 0, size: CGSize(width: 5, height: 5), grayscale: false)
        emitterNode.targetNode = self

        addChild(longLine)
        longLine.addChild(circle)
        circle.addChild(shortLine)
        shortLine.addChild(emitterNode)
    }

}
