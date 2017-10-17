//
//  App.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/12/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import Material

open class App {
    open static let colors = Colors.self
    open static let defaults = UserDefaults.standard
    open static let icons = Icon.self
    open static let strings = Strings.self
    
    open static var alert: Alert {
        return Alert()
    }
    
    open static func restart() {
        (UIApplication.shared.delegate as? AppDelegate)?.restart()
    }
    
    open static func logout(restart: Bool) {
        defaults[.token] = ""
        if restart {
            self.restart()
        }
    }
}
