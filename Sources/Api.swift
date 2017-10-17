//
//  Api.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/2/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Moya
import MoyaSugar
import Foundation


private struct Inner {
    static let provider = MoyaSugarProvider<App.Api>()
}

open class Api<F: ApiError> {
    @discardableResult
    open class func request<T: JSONAble>(_ target: App.Api.Request<T>, success: @escaping ((T) -> Void) ) -> ResultHandler<T, F> {
        let resultHandler = ResultHandler<T, F>()
        resultHandler.success { d, _ in
            success(d)
        }
        _ = Inner.provider.request(target) { result in
            switch result {
            case let .success(response):
                self.onSuccess(response, resultHandler)
            case let .failure(e):
                self.onFailure(e, resultHandler)
                print(e)
            }
        }
        
        return resultHandler
    }
    
    @discardableResult
    open class func request<T: JSONAble>(_ target: App.Api.Request<[T]>, success: @escaping (([T]) -> Void)) -> ArrayResultHandler<T, F> {
        return ArrayResultHandler(requester: self, target: target, key: arrayKey, success: success)
    }
    
    open class var arrayKey: String? {
        return nil
    }
    
    open class func onSuccess<T: JSONAble>(_ response: Moya.Response, _ resultHandler: ResultHandler<T, F>) {
        
    }
    
    open class func onFailure<T: JSONAble>(_ error: MoyaError, _ resultHandler: ResultHandler<T, F>) {
        
    }
}
