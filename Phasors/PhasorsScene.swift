//
//  PhasorsScene.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

private let maxNumberOfPhasors = 8

class PhasorsScene: SKScene {

    let beaconNode = SKNode()

    var numberOfPhasorNodes = 1 {
        didSet {
            configurePhasorNodes()
        }
    }
    var stemsEnabled: Bool = true {
        didSet {
            configurePhasorNodes()
        }
    }

    let thickness: CGFloat = 5
    let trailSegmentFadeOutDuration: NSTimeInterval = 2

    var previousBeaconPosition = CGPointZero
    var flippeds = [Bool](count: maxNumberOfPhasors, repeatedValue: false)
    var periods = [NSTimeInterval](count: maxNumberOfPhasors, repeatedValue: 2.0)
    var radii = [CGFloat](count: maxNumberOfPhasors, repeatedValue: 0.5)

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        configurePhasorNodes()
    }

    override func update(currentTime: NSTimeInterval) {
        let currentBeaconPosition = convertPoint(beaconNode.position, fromNode: beaconNode)

        let distance = hypot(
            previousBeaconPosition.x - currentBeaconPosition.x,
            previousBeaconPosition.y - currentBeaconPosition.y)
        let size = CGSize(width: distance, height: thickness)
        let rect = CGRect(origin: CGPointZero, size: size)
        let angle = atan2(
            currentBeaconPosition.y - previousBeaconPosition.y,
            currentBeaconPosition.x - previousBeaconPosition.x)

        let trailSegment = SKShapeNode(rect: rect)
        trailSegment.zRotation = angle
        trailSegment.position = previousBeaconPosition

        let color = UIView.appearance().tintColor
        trailSegment.fillColor = color
        trailSegment.lineWidth = 0

        addChild(trailSegment)

        trailSegment.runAction(SKAction.fadeOutWithDuration(trailSegmentFadeOutDuration)) {
            trailSegment.removeFromParent()
        }

        previousBeaconPosition = currentBeaconPosition
    }

    func reset() {
        resetProperties()
    }

    func flippedForPhasor(index: Int) -> Bool {
        return flippeds[index]
    }

    func setFlipped(flipped: Bool, forPhasor index: Int) {
        flippeds[index] = flipped
        configurePhasorNodes()
    }

    func periodForPhasor(index: Int) -> NSTimeInterval {
        return periods[index]
    }

    func setPeriod(period: NSTimeInterval, forPhasor index: Int) {
        periods[index] = period
        configurePhasorNodes()
    }

    func radiusForPhasor(index: Int) -> Float {
        return Float(radii[index])
    }

    func setRadius(radius: Float, forPhasor index: Int) {
        radii[index] = CGFloat(radius)
        configurePhasorNodes()
    }

    private func resetProperties() {
        flippeds = [Bool](count: maxNumberOfPhasors, repeatedValue: false)
        periods = [NSTimeInterval](count: maxNumberOfPhasors, repeatedValue: 2.0)
        radii = [CGFloat](count: maxNumberOfPhasors, repeatedValue: 0.5)
        numberOfPhasorNodes = 1
        stemsEnabled = true
    }

    private var phasorNodes = [PhasorNode]()
    private func configurePhasorNodes() {
        beaconNode.removeFromParent()
        removeChildrenInArray(phasorNodes)
        phasorNodes.removeAll(keepCapacity: true)

        for i in 0..<numberOfPhasorNodes {
            let phasorNode = PhasorNode(
                period: periods[i],
                radius: radii[i],
                flipped: flippeds[i],
                showStems: stemsEnabled)
            if let previousPhasorNode = phasorNodes.last {
                phasorNode.position = CGPoint(x: CGRectGetWidth(previousPhasorNode.line.frame), y: 0)
                previousPhasorNode.line.addChild(phasorNode)
            } else {
                let midX = CGRectGetMidX(frame), midY = CGRectGetMidY(frame)
                phasorNode.position = CGPoint(x: midX, y: midY)
                addChild(phasorNode)
            }

            phasorNodes.append(phasorNode)
        }

        if let finalPhasorNode = phasorNodes.last {
            beaconNode.position = CGPoint(x: finalPhasorNode.line.size.width/2, y: 0)
            finalPhasorNode.line.addChild(beaconNode)
        }
    }

}
