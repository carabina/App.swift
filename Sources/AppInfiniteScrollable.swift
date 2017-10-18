//
//  AppInfiniteScrollable.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/8/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

public protocol AppInfiniteScrollable: class {
    associatedtype T: JSONAble
    associatedtype F: ApiError
    
    var isPaginated: Bool { get }
    var isLoadingNextPage: Bool { get set }
    var isLastPageReached: Bool { get set }
    var currentPage: Int { get set }
    var data: [T] { get set }
    func didAddNewData(at indexPaths: [IndexPath])
    func animateLoadMore()
    func stopAnimatingLoadMore()
    
    static var requester: Api<F>.Type? { get }
    func requestFor(page: Int) -> App.Api.Request<[T]>?
    func handlePaginationRequestError(_ err: F)
}

fileprivate var IsPaginatedKey: UInt8 = 0
fileprivate var IsLoadingNextPageKey: UInt8 = 0
fileprivate var IsLastPageReachedKey: UInt8 = 0
fileprivate var CurrentPageKey: UInt8 = 0

extension AppInfiniteScrollable {
    public var isLoadingNextPage: Bool {
        get {
            return AppAssociatedObject.get(base: self, key: &IsLoadingNextPageKey) {
                false
            }
        }
        set {
            if newValue {
                animateLoadMore()
            } else {
                stopAnimatingLoadMore()
            }
            AppAssociatedObject.set(base: self, key: &IsLoadingNextPageKey, value: newValue)
        }
    }
    public var isLastPageReached: Bool {
        get {
            return AppAssociatedObject.get(base: self, key: &IsLastPageReachedKey) {
                false
            }
        }
        set {
            AppAssociatedObject.set(base: self, key: &IsLastPageReachedKey, value: newValue)
        }
    }
    
    public var currentPage: Int {
        get {
            return AppAssociatedObject.get(base: self, key: &CurrentPageKey) {
                1
            }
        }
        set {
            AppAssociatedObject.set(base: self, key: &CurrentPageKey, value: newValue)
        }
    }
    
    public func loadMoreIfNeeded() {
        guard
            isPaginated,
            !isLastPageReached,
            !isLoadingNextPage,
            let requester = type(of: self).requester,
            let target = requestFor(page: currentPage + 1)
            else { return }
        
        self.isLoadingNextPage = true
        requester.request(target){ newData in
            if newData.count == 0 {
                self.isLastPageReached = true
                return
            }
            
            self.currentPage = self.currentPage + 1
            let initialCount = self.data.count
            self.data += newData
            let indexPaths = (initialCount..<self.data.count).map { IndexPath(row: $0, section: 0) }
            self.didAddNewData(at: indexPaths)
            }.always { _, err in
                self.isLoadingNextPage = false
                
                if let err = err {
                    self.handlePaginationRequestError(err)
                }
        }
    }
    
    public func resetPagination() {
        currentPage = 1
        isLastPageReached = false
    }
    
    public func handlePaginationRequestError(_ err: F) {
        (self as? UIViewController)?.showNoInternetBannerIfNeeded(err)
    }
}
