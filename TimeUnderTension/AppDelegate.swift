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
        
        let tabBarController = UITabBarController()
        let create = CreateWorkoutViewController()
        let timer = TimerViewController()
        
        create.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        timer.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        let controllers = [create, timer]
    
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        window?.rootViewController = tabBarController
        
        window?.makeKeyAndVisible()
        return true
    }
}
