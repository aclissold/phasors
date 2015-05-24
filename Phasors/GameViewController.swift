//
//  GameViewController.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var phasorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    let gameScene = GameScene()

    let periods: [NSTimeInterval] = [8, 4, 2, 1, 0.5, 0.25]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        if skView.showsDrawCount || skView.showsFields || skView.showsFPS ||
            skView.showsNodeCount || skView.showsPhysics || skView.showsQuadCount {
                bottomConstraint.constant += 19
        }
        
        gameScene.scaleMode = .AspectFill
        gameScene.size = skView.frame.size

        skView.presentScene(gameScene)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func stepperChanged(sender: UIStepper) {
        let oldNumberOfSegments = phasorSegmentedControl.numberOfSegments
        let newNumberOfSegments = Int(sender.value)
        if newNumberOfSegments > oldNumberOfSegments {
            for var i = oldNumberOfSegments; i < newNumberOfSegments; ++i {
                phasorSegmentedControl.insertSegmentWithTitle("\(i+1)", atIndex: i, animated: true)
            }
        } else if newNumberOfSegments < oldNumberOfSegments {
            for i in 0..<(oldNumberOfSegments - newNumberOfSegments) {
                let index = phasorSegmentedControl.numberOfSegments-1
                phasorSegmentedControl.removeSegmentAtIndex(index, animated: true)
            }
        }

        gameScene.numberOfPhasorNodes = phasorSegmentedControl.numberOfSegments
    }

    @IBAction func periodSelected(sender: UISegmentedControl) {
        let period = periods[sender.selectedSegmentIndex]
        gameScene.setPeriod(period, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func radiusChanged(sender: UISlider) {
    }

}
