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

    @IBOutlet weak var controlCenterView: UIView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var phasorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    let gameScene = GameScene()

    let periods: [NSTimeInterval] = [8, 4, 2, 1, 0.5, 0.25]

    override func viewDidLoad() {
        super.viewDidLoad()

        addGestureRecognizers()
        
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

    func addGestureRecognizers() {
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        swipeUpGestureRecognizer.direction = .Up

        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        swipeDownGestureRecognizer.direction = .Down

        view.addGestureRecognizer(swipeUpGestureRecognizer)
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }

    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if !controlCenterView.hidden && recognizer.direction == .Down {
            // Hide.
            UIView.animateWithDuration(0.4, animations: {
                self.controlCenterView.frame.origin.y += self.controlCenterView.frame.size.height + self.bottomConstraint.constant
                }, completion: { _ in
                    self.controlCenterView.hidden = true
                })
        } else if controlCenterView.hidden && recognizer.direction == .Up {
            // Show.
            controlCenterView.hidden = false
            UIView.animateWithDuration(0.6,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.25,
                options: .CurveEaseIn,
                animations: {
                    self.controlCenterView.frame.origin.y -= self.controlCenterView.frame.size.height + self.bottomConstraint.constant
                }, completion: nil)
        }
    }

    @IBAction func stemsSwitchToggled(sender: UISwitch) {
        gameScene.stemsEnabled = sender.on
    }

    @IBAction func stepperChanged(sender: UIStepper) {
        let oldNumberOfSegments = phasorSegmentedControl.numberOfSegments
        let newNumberOfSegments = Int(sender.value)
        if newNumberOfSegments > oldNumberOfSegments {
            for i in oldNumberOfSegments..<newNumberOfSegments {
                phasorSegmentedControl.insertSegmentWithTitle("\(i+1)", atIndex: i, animated: true)
            }
        } else if newNumberOfSegments < oldNumberOfSegments {
            for i in 0..<(oldNumberOfSegments - newNumberOfSegments) {
                let index = phasorSegmentedControl.numberOfSegments-1
                phasorSegmentedControl.removeSegmentAtIndex(index, animated: true)
            }
        }

        if phasorSegmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            phasorSegmentedControl.selectedSegmentIndex = newNumberOfSegments-1
            phasorSelected(phasorSegmentedControl)
        }

        gameScene.numberOfPhasorNodes = phasorSegmentedControl.numberOfSegments
    }

    @IBAction func periodSelected(sender: UISegmentedControl) {
        let period = periods[sender.selectedSegmentIndex]
        gameScene.setPeriod(period, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func phasorSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        let period = gameScene.periodForPhasor(index)
        periodSegmentedControl.selectedSegmentIndex = find(periods, period)!

        let radius = gameScene.radiusForPhasor(index)
        radiusSlider.value = Float(radius)
    }

    @IBAction func radiusChanged(sender: UISlider) {
        gameScene.setRadius(sender.value, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
