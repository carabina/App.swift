//
//  AppCellModelRelatable.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/9/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

public protocol AppHasControls {
    var refreshControl: UIRefreshControl { get }
    var loadingOverlay: AppLoadingOverlayView { get }
}

public protocol AppCellModelRelatable: AppHasControls {
    associatedtype Cell: UIView
    associatedtype T: JSONAble
    associatedtype F: ApiError
    
    var data: [T] { get set }
    func willDisplay(cell: Cell, at row: Int, with item: T)
    func didEndDisplaying(cell: Cell, at row: Int)
    func didTap(item: T, at row: Int)
    func configure(cell: Cell, at row: Int, with item: T)
    
    static var requester: Api<F>.Type? { get }
    var request: App.Api.Request<[T]>? { get }
    func reloadData()
    func handleRequestError(_ err: F)
}

extension AppCellModelRelatable where Self: AppInfiniteScrollable {
    public func refreshingDidStart() {
        guard let requester = type(of: self).requester,
              let target = request else { return }
        
        requester.request(target) { data in
                self.data = data
                self.resetPagination()
                self.reloadData()
            }.always { _, msg in
                self.refreshControl.endRefreshing()
                self.loadingOverlay.hide()
                if let msg = msg {
                    self.handleRequestError(msg)
                }
        }
        
    }
    
    public func handleRequestError(_ err: F) {
        if err.isLocalError {
            if data.isEmpty {
                self.loadingOverlay.noInternet { [weak self] in
                    self?.refreshingDidStart()
                }
            } else {
                (self as? UIViewController)?.showNoInternetBanner()
            }
        }
    }
}
