//
//  PhasorsScene.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

private let maxNumberOfPhasors = 6

class PhasorsScene: SKScene {

    let beaconNode = SKNode()

    var numberOfPhasorNodes = 2 {
        didSet {
            configurePhasorNodes()
        }
    }
    var stemsEnabled: Bool = true {
        didSet {
            configurePhasorNodes()
        }
    }

    private var flippeds = [Bool](count: maxNumberOfPhasors, repeatedValue: false)
    private var periods = [NSTimeInterval](count: maxNumberOfPhasors, repeatedValue: 2.0)
    private var radii = [CGFloat](count: maxNumberOfPhasors, repeatedValue: 0.5)

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        configurePhasorNodes()
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
        numberOfPhasorNodes = 2
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
            beaconNode.position = CGPoint(x: finalPhasorNode.line.frame.width, y: 0)
            finalPhasorNode.line.addChild(beaconNode)
        }
    }

}
