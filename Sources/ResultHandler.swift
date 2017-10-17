//
//  ResultHandler.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/26/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

open class ResultHandler<T: JSONAble, F: ApiError> {
    
    public typealias SuccessClosure = (_ data: T, _ headers: [AnyHashable: Any]) -> Void
    public typealias FailureClosure = (F) -> Void
    public typealias AlwaysClosure = ((data: T, headers: [AnyHashable: Any])?, F?) -> Void
    
    private var success: SuccessClosure? {
        didSet {
            if let result = result {
                success?(result.0, result.1)
            }
        }
    }
    
    private var failure: FailureClosure? {
        didSet {
            if let error = error {
                failure?(error)
            }
        }
    }
    
    private var always: AlwaysClosure? {
        didSet {
            if let result = result {
                always?(result, nil)
            } else if let error = error {
                always?(nil, error)
            }
        }
    }
    
    open var result: (T, [AnyHashable: Any])? {
        didSet {
            if let result = result {
                success?(result.0, result.1)
                always?(result, nil)
            }
        }
    }
    
    open var error: F? {
        didSet {
            if let error = error {
                failure?(error)
                always?(nil, error)
            }
        }
    }
    
    @discardableResult
    open func success(closure: @escaping SuccessClosure) -> Self {
        success = closure
        return self
    }
    
    @discardableResult
    open func failure(closure: @escaping FailureClosure) -> Self {
        failure = closure
        return self
    }
    
    @discardableResult
    open func always(closure: @escaping AlwaysClosure) -> Self {
        always = closure
        return self
    }
}
