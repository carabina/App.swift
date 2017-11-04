//
//  AppIconButton.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/12/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Material

open class AppIconButton: IconButton {
    open override func prepare() {
        super.prepare()
        self.titleColor = App.colors.tint
        self.pulseColor = App.colors.tint
        self.tintColor = App.colors.tint
    }
}
