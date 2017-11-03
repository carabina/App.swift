//
//  AppTabsController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/8/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import Material

open class AppTabsController: TabsController {
    open override func prepare() {
        super.prepare()
        
        tabBar.lineColor = App.colors.primary
        tabBar.isDividerHidden = true // we use DepthPreset (shadow)
        tabBar.depthPreset = .depth1
        tabBar.tabItems.forEach {
            $0.fontSize = 16
        }
        
        tabBarAlignment = .top
        tabBar.lineAlignment = .bottom
        tabBar.heightPreset = .medium
        tabBar.tabItems.forEach { $0.titleColor = .darkGray }
    }
    
    open override func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        super.tabBar(tabBar: tabBar, willSelect: tabItem)
        tabBar.selectedTabItem?.titleColor = .darkGray
        tabItem.titleColor = App.colors.primary
    }
}
