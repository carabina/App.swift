//
//  AppLoadingButton.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/13/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import Material

open class AppLoadingButton: RaisedButton {
    open override func prepare() {
        super.prepare()
        
        self.titleColor = App.colors.tint
        self.backgroundColor = App.colors.primary
        self.pulseAnimation = .none
    }
    
    open override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? App.colors.primary : .lightGray
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            guard !isLoading else { return }
            UIView.animate(withDuration: 0.25) {
                self.titleLabel?.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }
    
    
    open var isLoading: Bool = false {
        didSet {
            let tag = 2312
            let oldIndicator = self.viewWithTag(tag) as? UIActivityIndicatorView
            if isLoading && oldIndicator == nil {
                let indicator = UIActivityIndicatorView()
                indicator.tag = tag
                self.addView(indicator).makeConstraints {
                    $0.center.equalToSuperview()
                }
                indicator.startAnimating()
                titleLabel?.alpha = 0
            } else {
                if let indicator = oldIndicator {
                    indicator.stopAnimating()
                    titleLabel?.alpha = 1
                    indicator.removeFromSuperview()
                }
            }
            self.isUserInteractionEnabled = !isLoading
        }
    }
}
