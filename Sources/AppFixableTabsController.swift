//
//  AppFixableTabsController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/8/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import Material

open class AppFixableTabsController: AppViewController, TabsControllerDelegate {
    
    open var viewControllers: [UIViewController] {
        return []
    }
    
    open lazy var childTabsController: AppTabsController = {
        let controller = AppTabsController(viewControllers: self.viewControllers)
        controller.delegate = self
        return controller
    }()
    open let scrollView = AppFixableScrollView()
    open let refreshControl = UIRefreshControl()
    open var isRefreshControlEnabled: Bool {
        get {
            return scrollView.subviews.first == refreshControl
        }
        
        set {
            guard newValue != isRefreshControlEnabled else { return }
            if newValue {
                scrollView.alwaysBounceVertical = true
                scrollView.insertSubview(refreshControl, at: 0)
            } else {
                refreshControl.removeFromSuperview()
            }
        }
    }
    open weak var delegate: AppFixableTabsControllerDelegate?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addView(scrollView).makeConstraints { $0.edges.equalToSuperview() }
        
        self.view.backgroundColor = .white
        prepareTabsViewController()
        
        self.isRefreshControlEnabled = true
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            self?.refreshingDidStart()
            self?.viewControllers.forEach {
                let v = $0 as? AppHasControls
                v?.loadingOverlay.showLoading()
                v?.refreshControl.beginRefreshingManually()
            }
        }).disposed(by: disposeBag)
        refreshControl.beginRefreshingManually()
    }
    
    open func refreshingDidStart() { }
    
    open func prepareTabsViewController() {
        self.addChildViewController(childTabsController)
        self.scrollView.bottomContainer.addView(childTabsController.view).makeConstraints {
            $0.edges.equalToSuperview()
        }
        childTabsController.didMove(toParentViewController: self)
        
        childTabsController.displayStyle = .full
        let tabBar = childTabsController.tabBar
        self.scrollView.fixedContainer.addSubview(tabBar)
        scrollView.fixedContainer.heightPreset = tabBar.heightPreset
        tabBar.isDividerHidden = false /// we depth for bottom shadow, and divider for the top line (default divider alignment is .top for tabBar)
        
        self.scrollView.scrollViewToChangeOffset = delegate?.appFixableTabsController?(self, scrollViewAt: 0)
    }
    
    open func tabsController(tabsController: TabsController, willSelect viewController: UIViewController) {
        let index = tabsController.viewControllers.index(of: viewController)!
        self.scrollView.scrollViewToChangeOffset = delegate?.appFixableTabsController?(self, scrollViewAt: index)
    }
}


@objc
public protocol AppFixableTabsControllerDelegate {
    @objc
    optional func appFixableTabsController(_ controller: AppFixableTabsController, scrollViewAt index: Int) -> UIScrollView?
}
