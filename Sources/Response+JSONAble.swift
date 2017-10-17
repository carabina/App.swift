//
//  Response+JSONAble.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/6/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//


import Foundation
import Moya
import SwiftyJSON

public extension Response {

    /// Maps data received from the signal into an object which implements the JSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: JSONAble>(to type:T.Type) throws -> T {
        let jsonObject = try mapJSON()
        
        guard let mappedObject = T(json: JSON(jsonObject)) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return mappedObject
    }

    /// Maps data received from the signal into an array of objects which implement the JSONAble protocol
    /// If the conversion fails, the signal errors.
    public func map<T: JSONAble>(to type:[T.Type]) throws -> [T] {
        let jsonObject = try mapJSON()
        
        let mappedArray = JSON(jsonObject)
        let mappedObjectsArray = mappedArray.arrayValue.flatMap { T(json: $0) }
        
        return mappedObjectsArray
    }
}
