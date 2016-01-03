//
//  ViewController.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var controlCenterView: UIView!
    @IBOutlet weak var stemsSwitch: UISwitch!
    @IBOutlet weak var flippedSwitch: UISwitch!
    @IBOutlet weak var trailSlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var phasorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    let phasorsScene = PhasorsScene()
    let periods: [NSTimeInterval] = [4, 3, 2, 1, 0.5, 0.25]

    var controlCenterViewHiding = false
    var originalBottomConstraintConstant: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapView.addGestureRecognizer(tapGestureRecognizer)
        phasorSegmentedControl.removeSegmentAtIndex(1, animated: false)

        guard let skView = view as? SKView else {
            return
        }

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        if skView.showsDrawCount || skView.showsFields || skView.showsFPS ||
            skView.showsNodeCount || skView.showsPhysics || skView.showsQuadCount {
                bottomConstraint.constant += 19
        }
        originalBottomConstraintConstant = bottomConstraint.constant

        phasorsScene.scaleMode = .AspectFill
        phasorsScene.size = skView.frame.size

        skView.presentScene(phasorsScene)
    }

    func handleTap(recognizer: UITapGestureRecognizer) {
        view.layoutIfNeeded()

        if controlCenterViewHiding {
            self.bottomConstraint.constant +=
                self.controlCenterView.frame.size.height +
                self.originalBottomConstraintConstant
            controlCenterViewHiding = false
            UIView.animateWithDuration(0.6,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.25,
                options: .CurveEaseIn,
                animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            self.bottomConstraint.constant -=
                self.controlCenterView.frame.size.height +
                self.originalBottomConstraintConstant
            controlCenterViewHiding = true
            UIView.animateWithDuration(0.4) {
                self.view.layoutIfNeeded()
            }
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
        phasorsScene.reset()
        reset()
    }

    func reset() {
        stemsSwitch.setOn(true, animated: true)
        flippedSwitch.setOn(false, animated: true)
        setValue(0.5, forSlider: trailSlider)
        setValue(0.5, forSlider: radiusSlider)
        periodSegmentedControl.selectedSegmentIndex = 2
        setNumberOfPhasorSegments(1)
        stepper.value = 1
    }

    @IBAction func stemsSwitchToggled(sender: UISwitch) {
        phasorsScene.stemsEnabled = sender.on
    }

    @IBAction func flippedSwitchToggled(sender: UISwitch) {
        phasorsScene.setFlipped(sender.on, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func stepperChanged(sender: UIStepper) {
        setNumberOfPhasorSegments(Int(sender.value))
        phasorsScene.numberOfPhasorNodes = phasorSegmentedControl.numberOfSegments
    }

    @IBAction func periodSelected(sender: UISegmentedControl) {
        let period = periods[sender.selectedSegmentIndex]
        phasorsScene.setPeriod(period, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func phasorSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        let period = phasorsScene.periodForPhasor(index)
        periodSegmentedControl.selectedSegmentIndex = periods.indexOf(period)!

        let value = Float(phasorsScene.radiusForPhasor(index))
        setValue(value, forSlider: radiusSlider)

        let on = phasorsScene.flippedForPhasor(index)
        flippedSwitch.setOn(on, animated: true)
    }

    @IBAction func radiusSliderChanged(sender: UISlider) {
        phasorsScene.setRadius(sender.value, forPhasor: phasorSegmentedControl.selectedSegmentIndex)
    }

    @IBAction func trailSliderChanged(sender: UISlider) {
        // TODO
    }

}
