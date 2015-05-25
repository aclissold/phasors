//
//  PhasorNode.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/24/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class PhasorNode: SKNode {

    let line = SKSpriteNode()
    let trail = SKEmitterNode()

    private let particleBirthRate: CGFloat = 500
    private let radiusScaler: CGFloat = 60
    private var globalTintColor: SKColor {
        return (UIApplication.sharedApplication().windows.first as! UIWindow).rootViewController!.view.tintColor
    }

    init(period: NSTimeInterval, radius: CGFloat, flipped: Bool, showStems shouldShowStems: Bool) {
        super.init()

        if shouldShowStems {
            line.color = SKColor.blackColor()
        } else {
            line.color = SKColor.clearColor()
        }
        line.size = CGSize(width: radiusScaler*radius, height: 1)
        line.anchorPoint = CGPoint(x: 0, y: 0.5)

        var angle = CGFloat(2*M_PI)
        if flipped {
            angle *= -1
        }
        let rotationAction = SKAction.rotateByAngle(angle, duration: period)
        line.runAction(SKAction.repeatActionForever(rotationAction))

        let circle = SKShapeNode(circleOfRadius: radiusScaler*radius)
        if shouldShowStems {
            circle.strokeColor = globalTintColor
        }

        trail.position = CGPoint(x: line.size.width, y: 0)
        trail.particleAlphaSpeed = CGFloat(-1/period)
        trail.particleBirthRate = particleBirthRate
        trail.particleTexture = SKTexture(imageNamed: "Circle")
        trail.particleColor = globalTintColor
        trail.particleColorBlendFactor = 1
        trail.particleLifetime = CGFloat(period)
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
