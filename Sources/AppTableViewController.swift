//
//  AppTableViewController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/3/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

open class AppTableViewController<Cell: AppTableViewCell, T: JSONAble, F: ApiError>: AppViewController, UITableViewDataSource, UITableViewDelegate {
    open let tableView  = UITableView()
    open var data: [T] = []
    open var refreshControl = UIRefreshControl()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(Cell.self)
        tableView.rowHeight = Cell.rowHeight
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.insertSubview(refreshControl, at: 0)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            self?.refreshingDidStart()
        }).disposed(by: disposeBag)
        refreshControl.beginRefreshingManually()
        
        tableView.backgroundColor = .clear
        
        self.view.addView(loadingOverlay).makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    open let loadingOverlay = AppLoadingOverlayView()
    
    open let noItemLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = App.strings.noItem
        return label
    }()
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty && tableView.backgroundView == nil {
            tableView.backgroundView = noItemLabel
        }
        
        tableView.backgroundView?.isHidden = !data.isEmpty
        return data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(Cell.self, for: indexPath)
        let item = data[indexPath.row]
        configure(cell: cell, at: indexPath.row, with: item)
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        self.didTap(item: item, at: indexPath.row)
    }
    
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.willDisplay(cell: cell as! Cell, at: indexPath.row, with: data[indexPath.row])
        
        if indexPath.row == data.count - 1 {
            loadMoreIfNeeded()
        }
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.didEndDisplaying(cell: cell as! Cell, at: indexPath.row)
    }

    open func willDisplay(cell: Cell, at row: Int, with item: T) { }
    open func didEndDisplaying(cell: Cell, at row: Int) { }
    open func didTap(item: T, at row: Int) { }
    open func configure(cell: Cell, at row: Int, with item: T) { }
    
    open func reloadData() {
        self.tableView.reloadData()
    }
    
    open class var requester: Api<F>.Type? {
        return nil
    }
    
    open var request: App.Api.Request<[T]>? {
        return nil
    }
    
    open func requestFor(page: Int) -> App.Api.Request<[T]>? {
        return nil
    }
}

extension AppTableViewController: AppInfiniteScrollable {
    open func didAddNewData(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    open func animateLoadMore() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        indicator.frame.size.height = indicator.intrinsicContentSize.height + 20
        tableView.tableFooterView = indicator
    }
    
    open func stopAnimatingLoadMore() {
        tableView.tableFooterView = UIView()
    }
}

extension AppTableViewController: AppCellModelRelatable { } //just to keep track of changes
