//
//  App.Colors.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

extension App {
    public struct Colors {
        public static var primary = UIColor(rgb: 0x1976d2)
        public static var darkPrimary = UIColor(rgb: 0x004ba0)
        public static var tint = UIColor.white
        public static var background = UIColor.white
        public static var background2 = UIColor(rgb: 0xfafafa)
        
        public static var success = UIColor(rgb: 0x53de00)
        public static var warning = UIColor(rgb: 0xffb622)

        fileprivate static var originalAppColor: UIColor = { Colors.primary }()
    }
    
    private static var navigationController: UINavigationController? {
        return UIViewController.toppestViewController.navigationController
    }
    
    ///Call in viewWillDisappear to get color change blending during swipe pop gesture
    public static func restoreColor(from controller: UIViewController) {
        if !navigationController!.viewControllers.contains(controller) { //if controller is not in hierarchy
            changeColor(to: App.colors.originalAppColor)
        }
    }
    
    /// Call in viewDidLoad to set App.colors.primary before creating any view
    /// Call in viewWillAppear to set color again if swipeGesture is cancelled.
    public static func changeColor(to color: UIColor) {
        _ = App.colors.originalAppColor //cause to evaluate
        App.colors.primary = color
        navigationController!.navigationBar.barTintColor = color
    }
}
