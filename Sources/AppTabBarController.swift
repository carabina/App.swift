//
//  AppTabBarController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/12/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

open class AppTabBarController: UITabBarController {
    public convenience init(viewControllers: [UIViewController]) {
        self.init()
        self.setViewControllers(viewControllers, animated: false)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = App.colors.background
    }
}
