//
//  App.Alert.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/30/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

extension App {
    open class Alert {
        
        public typealias ButtonStyle = UIAlertActionStyle
        open let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        open func title(_ string: String?) -> Self {
            alertController.title = string
            return self
        }
        
        open func message(_ string: String?) -> Self {
            alertController.message = string
            return self
        }
        
        open func present() {
            alertController.present(animated: true)
        }
        
        open func addButton(title: String, style: ButtonStyle, handler: (()->Void)? = nil) -> Self {
            alertController.addAction(UIAlertAction(title: title, style: style) { _ in
                handler?()
            })
            
            return self
        }
    }
}

extension App.Alert {
    open func ok(title: String?, message: String?) {
        self.title(title)
            .message(message)
            .addButton(title: "OK", style: .default)
            .present()
    }
    
    open func okCancel(title: String?, message: String?, didTapOk: @escaping () -> Void) {
        self.title(title)
            .message(message)
            .addButton(title: "OK", style: .default, handler: didTapOk)
            .addButton(title: "İmtina", style: .cancel)
            .present()
    }
    
}
