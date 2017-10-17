//
//  AppNavigationController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/12/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Material

open class AppNavigationController: NavigationController {
    public convenience init(rootViewController: UIViewController, tabBarTitle: String?, tabBarImage: UIImage? = nil, tabBarSelectedImage: UIImage? = nil) {
        self.init(rootViewController: rootViewController)
        
        self.tabBarItem.title = tabBarTitle
        self.tabBarItem.image = tabBarImage
        self.tabBarItem.selectedImage = tabBarSelectedImage
    }
    
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        v.backgroundColor = App.colors.primary
        v.tintColor = App.colors.tint
        v.backButtonImage = Icon.arrowBack
    }
    
}

