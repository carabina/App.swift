//
//  AppCollectionViewController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import RxSwift

open class AppCollectionViewController<Cell: AppCollectionViewCell, T: JSONAble, F: ApiError>: AppViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    open var data: [T] = []
    open var refreshControl = UIRefreshControl()
    
    open var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    open var isRefreshControlEnabled: Bool {
        get {
            if #available(iOS 10.0, *) {
                return collectionView.refreshControl == refreshControl
            } else {
                return collectionView.subviews.first == refreshControl
            }
        }
        set {
            guard newValue != isRefreshControlEnabled else { return }
            if newValue {
                if #available(iOS 10.0, *) {
                    collectionView.refreshControl = refreshControl
                } else {
                    collectionView.insertSubview(refreshControl, at: 0)
                }
            } else {
                refreshControl.endRefreshing()
                if #available(iOS 10.0, *) {
                    collectionView.refreshControl = nil
                } else {
                    refreshControl.removeFromSuperview()
                }
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        isRefreshControlEnabled = true
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            self?.refreshingDidStart()
        }).disposed(by: disposeBag)
        refreshControl.beginRefreshingManually()
    
    
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self)
        if isPaginated {
            collectionView.register(LoadMoreFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loadMoreFooter")
        }
        prepare(flowLayout: flowLayout)
        
        self.view.addView(loadingOverlay).makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    open let loadingOverlay = AppLoadingOverlayView()
    
    open let noItemLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = "Heçnə yoxdur"
        return label
    }()

    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.isEmpty && collectionView.backgroundView == nil {
            collectionView.backgroundView = noItemLabel
        }
        
        collectionView.backgroundView?.isHidden = !data.isEmpty
        return data.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(Cell.self, for: indexPath)
        let item = self.data[indexPath.row]
        configure(cell: cell, at: indexPath.row, with: item)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTap(item: data[indexPath.row], at: indexPath.row)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.willDisplay(cell: cell as! Cell, at: indexPath.row, with: data[indexPath.row])
        
        if indexPath.row == data.count - 1 {
            loadMoreIfNeeded()
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.didEndDisplaying(cell: cell as! Cell, at: indexPath.row)
    }
    
    open func prepare(flowLayout: UICollectionViewFlowLayout) {
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size(for: data[indexPath.row], at: indexPath.row)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            if isPaginated {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadMoreFooter", for: indexPath) as! LoadMoreFooter
                return footer
            }
        default:
            break
        }
        return self.supplimentaryView(of: kind)
    }
    
    
    
    open func willDisplay(cell: Cell, at row: Int, with item: T) { }
    open func didEndDisplaying(cell: Cell, at row: Int) { }
    open func didTap(item: T, at row: Int) { }
    open func configure(cell: Cell, at row: Int, with item: T) { }
    open func size(for item: T, at row: Int) -> CGSize { return flowLayout.itemSize }
    open func supplimentaryView(of kind: String) -> UICollectionReusableView { return UICollectionReusableView() }
    
    open func reloadData() {
        self.collectionView.reloadData()
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
    
    private class LoadMoreFooter: UICollectionReusableView {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        override init(frame: CGRect) {
            super.init(frame: frame)
            prepare()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func prepare() {
            self.addView(indicator).makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-10)
            }
            indicator.startAnimating()
        }
    }
}

extension AppCollectionViewController: AppInfiniteScrollable {
    open func didAddNewData(at indexPaths: [IndexPath]) {
        self.collectionView.insertItems(at: indexPaths)
    }
    
    open func animateLoadMore() {
        flowLayout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 30)
    }
    
    open func stopAnimatingLoadMore() {
        flowLayout.footerReferenceSize = .zero
    }
}

extension AppCollectionViewController: AppCellModelRelatable { } //just to keep track of changes
