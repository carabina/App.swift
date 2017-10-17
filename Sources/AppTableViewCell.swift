//
//  AppTableViewCell.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

open class AppTableViewCell: UITableViewCell {
    open class var identifier: String {
        return NSStringFromClass(self)
    }
    
    open class var rowHeight: CGFloat {
        return 55
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    open func prepare() {
        self.backgroundColor = .clear
    }
}
