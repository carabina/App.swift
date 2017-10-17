//
//  AppViewController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/5/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

open class AppViewController: UIViewController {
    open let disposeBag = DisposeBag()
    open var contentView: UIView {
        return self.view
    }
    
    open override var title: String? {
        didSet {
            self.navigationItem.title = title
            self.tabItem.title = title
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButton.tintColor = App.colors.tint
        self.navigationItem.backButton.pulseColor = App.colors.tint
        self.navigationItem.titleLabel.textColor = App.colors.tint
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = App.colors.background
    }
    
    open func addView(_ view: UIView) -> ConstraintViewDSL {
        return self.contentView.addView(view)
    }
}

