//
//  Paramable.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/6/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

public typealias Params = [String: Any]
public protocol Paramable {
    func toParams() -> Params
}
