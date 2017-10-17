//
//  AppDelegate.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 7/28/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

open class AppDelegate: UIResponder, UIApplicationDelegate {

    open var window: UIWindow?

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        
        restart()
        prepare()
        return true
    }
    
    open func restart() {
        let keyWindow = UIApplication.shared.keyWindow!
        let controller = createRootViewController()
        keyWindow.rootViewController = controller
        
        controller.view.alpha = 0.7
        UIView.animate(withDuration: 0.5, animations: {
            controller.view.alpha = 1.0
        })
    }
    
    open func prepare() {}
    
    open func createRootViewController() -> UIViewController {
        return isAuthorized ? createMainViewController() : createEntryViewController()
    }
    
    open func createMainViewController() -> UIViewController {
        return UIViewController()
    }
    
    open func createEntryViewController() -> UIViewController {
        return UIViewController()
    }
    
    open var isAuthorized: Bool {
        return !App.defaults[.token].isEmpty
    }
}

