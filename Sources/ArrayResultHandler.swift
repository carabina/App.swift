//
//  ArrayResultHandler.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/26/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

//I know this is a bit messy. Needs to be rewritten
open class ArrayResultHandler<T: JSONAble, F: ApiError> {
    private let resultHandler: ResultHandler<ArrayWrapper<T>, F>

    public typealias SuccessClosure = (_ data: [T], _ headers: [AnyHashable: Any]) -> Void
    public typealias FailureClosure = (F) -> Void
    public typealias AlwaysClosure = ((data: [T], headers: [AnyHashable: Any])?, F?) -> Void
    
    
    var arrayKey: String?
    public init(requester: Api<F>.Type, target: App.Api, key: String?, success: @escaping ([T]) -> Void) {
        let r = App.Api.Request<ArrayWrapper<T>>(target.route)
        r.params = target.params
        r.task = target.task
        arrayKey = key
        resultHandler = requester.request(r) { data in
            success(data.getArray(key: key))
        }
    }

    
    @discardableResult
    open func success(closure: @escaping SuccessClosure) -> Self {
        let arrayKey = self.arrayKey
        resultHandler.success { (data, headers) in
            closure(data.getArray(key: arrayKey), headers)
        }
        return self
    }
    
    @discardableResult
    open func failure(closure: @escaping FailureClosure) -> Self {
        resultHandler.failure(closure: closure)
        return self
    }
    
    @discardableResult
    open func always(closure: @escaping AlwaysClosure) -> Self {
        let arrayKey = self.arrayKey
        resultHandler.always { (result, err) in
            if let result = result {
                closure((data: result.data.getArray(key: arrayKey), headers: result.headers), nil)
            } else {
                closure(nil, err)
            }
        }
        return self
    }
    
    private final class ArrayWrapper<T: JSONAble>: JSONAble {
        private var array: [T]!
        var json: JSON
        
        init?(json: JSON) {
            self.json = json
        }
        
        func getArray(key: String?) -> [T] {
            if array == nil {
                let j = key == nil ? json : json[key!]
                self.array = j.arrayValue.flatMap { T(json: $0) }
            }
            
            return array
        }
    }
}
