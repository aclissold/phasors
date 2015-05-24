//
//  PhasorNode.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/24/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class PhasorNode: SKNode {

    let line = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 30, height: 1))
    let trail = SKEmitterNode()

    private let defaultPeriod: NSTimeInterval = 2
    private let particleBirthRate: CGFloat = 500
    private var globalTintColor: SKColor {
        return (UIApplication.sharedApplication().windows.first as! UIWindow).rootViewController!.view.tintColor
    }

    override init() {
        super.init()

        let circle = SKShapeNode(circleOfRadius: 30)
        circle.strokeColor = globalTintColor

        line.anchorPoint = CGPoint(x: 0, y: 0.5)
        let rotationAction = SKAction.rotateByAngle(CGFloat(2*M_PI), duration: defaultPeriod)
        line.runAction(SKAction.repeatActionForever(rotationAction))

        trail.position = CGPoint(x: line.size.width, y: 0)
        trail.particleAlphaSpeed = CGFloat(-1/defaultPeriod)
        trail.particleBirthRate = particleBirthRate
        trail.particleTexture = SKTexture(imageNamed: "Circle")
        trail.particleColor = globalTintColor
        trail.particleColorBlendFactor = 1
        trail.particleLifetime = CGFloat(defaultPeriod)
        trail.targetNode = self

        addChild(circle)
        circle.addChild(line)
        line.addChild(trail)
    }

    func showTrail() {
        trail.particleBirthRate = particleBirthRate
    }

    func hideTrail() {
        trail.particleBirthRate = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
