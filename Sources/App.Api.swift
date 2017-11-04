//
//  App.Api.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/2/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import MoyaSugar
import Moya

extension App {
    open class Api {
        open static var baseURL = URL(string: "http://example.com")!
        open static var defaultHeaders: () -> [String: String] = {
            [
                "Accept": "application/json",
                "Authorization": App.defaults[.token]
            ]
        }
        
        open var route: Route
        open var params: Parameters?
        open var task: Task = .request
        
        public init(_ route: Route) {
            self.route = route
        }
        
        open class Request<T>: Api { }
    }
}

extension App.Api: SugarTargetType {
    public var sampleData: Data {
        return Data()
    }
    
    public var baseURL: URL {
        return App.Api.baseURL
    }
    
    public var httpHeaderFields: [String: String]? {
        return App.Api.defaultHeaders()
    }
}

extension App.Api {
    public convenience init( _ string: String) {
        self.init(.get(string))
    }
}
