//
//  AppCollectionViewCell.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/15/17.
//  Copyright © 2017 ATL Info Tech. All rights reserved.
//

import UIKit

open class AppCollectionViewCell: UICollectionViewCell {
    open class var identifier: String {
        return NSStringFromClass(self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    open var usesDefaultHighlighting = true
    
    open override var isHighlighted: Bool {
        didSet {
            if usesDefaultHighlighting {
                UIView.animate(withDuration: 0.25) {
                    let scale: CGFloat = 1.04
                    self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
                }
            }
        }
    }
    
    open func prepare() { }
}
