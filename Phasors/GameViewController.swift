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
    @IBOutlet weak var stemsSwitch: UISwitch!
    @IBOutlet weak var flippedSwitch: UISwitch!
    @IBOutlet weak var trailSlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var phasorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    let gameScene = GameScene()

    let periods: [NSTimeInterval] = [4, 3, 2, 1, 0.5, 0.25]

    override func viewDidLoad() {
        super.viewDidLoad()

        addGestureRecognizers()

        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
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

    func setValue(value: Float, forSlider slider: UISlider) {
        UIView.animateWithDuration(0.5, delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: .CurveEaseIn,
            animations: {
                slider.setValue(value, animated: true)
            }, completion: nil)
    }

    func setNumberOfPhasorSegments(newNumberOfSegments: Int) {
        let oldNumberOfSegments = phasorSegmentedControl.numberOfSegments
        if newNumberOfSegments > oldNumberOfSegments {
            for i in oldNumberOfSegments..<newNumberOfSegments {
                phasorSegmentedControl.insertSegmentWithTitle("\(i+1)", atIndex: i, animated: true)
            }
        } else if newNumberOfSegments < oldNumberOfSegments {
            for _ in 0..<(oldNumberOfSegments - newNumberOfSegments) {
                let index = phasorSegmentedControl.numberOfSegments-1
                phasorSegmentedControl.removeSegmentAtIndex(index, animated: true)
            }
        }

        if phasorSegmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            phasorSegmentedControl.selectedSegmentIndex = newNumberOfSegments-1
            phasorSelected(phasorSegmentedControl)
        }

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: Actions

    @IBAction func resetButtonPressed(sender: UIButton) {
        gameScene.reset()
        reset()
    }

    func reset() {
        stemsSwitch.setOn(true, animated: true)
        flippedSwitch.setOn(false, animated: true)
        setValue(0.5, forSlider: trailSlider)
        setValue(0.5, forSlider: radiusSlider)
        periodSegmentedControl.selectedSegmentIndex = 2
        setNumberOfPhasorSegments(2)
        stepper.value = 2
    }

    @IBAction func stemsSwitchToggled(sender: UISwitch) {
        gameScene.stemsEnabled = sender.on
    }

    @IBAction func flippedSwitchToggled(sender: UISwitch) {
        gameScene.setFlipped(sender.on, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func stepperChanged(sender: UIStepper) {
        setNumberOfPhasorSegments(Int(sender.value))
        gameScene.numberOfPhasorNodes = phasorSegmentedControl.numberOfSegments
    }

    @IBAction func periodSelected(sender: UISegmentedControl) {
        let period = periods[sender.selectedSegmentIndex]
        gameScene.setPeriod(period, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func phasorSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        let period = gameScene.periodForPhasor(index)
        periodSegmentedControl.selectedSegmentIndex = periods.indexOf(period)!

        let value = Float(gameScene.radiusForPhasor(index))
        setValue(value, forSlider: radiusSlider)

        let on = gameScene.flippedForPhasor(index)
        flippedSwitch.setOn(on, animated: true)
    }

    @IBAction func radiusSliderChanged(sender: UISlider) {
        gameScene.setRadius(sender.value, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func trailSliderChanged(sender: UISlider) {
        gameScene.trailDuration = sender.value
    }

}
