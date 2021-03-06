//
//  AppDelegate.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let homeViewController = HomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let rootNavController = window?.rootViewController as? UINavigationController else { return }
        guard let timerViewController = rootNavController.topViewController as? TimerViewController else { return }
        timerViewController.refreshStopWatchTime()
    }
}
