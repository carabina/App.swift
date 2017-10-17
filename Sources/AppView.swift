//
//  AppView.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/6/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

open class AppView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    open func prepare() { }
}
