//
//  ApiError.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/15/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

public protocol ApiError: Error {
    var isLocalError: Bool { get }
}
