//
//  AppCardCell.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/5/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

open class AppCardCell: AppCollectionViewCell {
    open override func prepare() {
        self.backgroundColor = .white
        self.cornerRadiusPreset = .cornerRadius1
        self.depthPreset = .depth3
        
        self.contentView.cornerRadiusPreset = cornerRadiusPreset
        self.contentView.clipsToBounds = true
    }
}
