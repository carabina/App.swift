//
//  JSONAble.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/6/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias JSON = SwiftyJSON.JSON

public protocol JSONAble {
    init?(json: JSON)
}

extension String : JSONAble  {
    public init?(json: JSON){
        self.init(json.stringValue)
    }
}

extension Int : JSONAble  {
    public init?(json: JSON){
        self.init(json.intValue)
    }
}

extension Float : JSONAble {
    public init?(json: JSON){
        self.init(json.floatValue)
    }
}

extension Double : JSONAble {
    public init?(json: JSON){
        self.init(json.doubleValue)
    }
}

extension Bool : JSONAble {
    public init?(json: JSON){
        self.init(json.boolValue)
    }
}
