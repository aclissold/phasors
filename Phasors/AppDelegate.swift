//
//  AppDelegate.swift
//  Phasors
//
//  Created by Andrew Clissold on 5/9/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        theme()
        return true
    }

    func theme() {
        let tintColor = UIColor(red: 150.0/255.0, green: 0, blue: 0, alpha: 1)

        UIView.appearance().tintColor = tintColor
        UISwitch.appearance().onTintColor = tintColor
    }

}

