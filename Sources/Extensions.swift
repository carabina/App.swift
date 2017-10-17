//
//  Extensions.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/4/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import SnapKit
import Material

public extension UIView {
    func addView(_ view: UIView) -> ConstraintViewDSL {
        self.addSubview(view)
        return view.snp
    }
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, aalpha: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(aalpha) / 255.0)
    }
    
    convenience init(argb: UInt32) {
        self.init(red:Int(argb >> 16) & 0xff, green:Int(argb >> 8) & 0xff, blue:Int(argb) & 0xff, aalpha: Int(argb >> 24) & 0xff)
    }
    
    convenience init(rgb: UInt32) {
        self.init(argb: (UInt32(0xff) << 24) | rgb)
    }
}
public extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


public extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

public extension UIButton {
    var fontSize: CGFloat {
        set {
            self.titleLabel!.font = self.titleLabel!.font.withSize(newValue)
        }
        get {
            return self.titleLabel!.font.pointSize
        }
    }
}

public extension UILabel {
    var fontSize: CGFloat {
        set {
            self.font = self.font?.withSize(newValue) ?? UIFont.systemFont(ofSize: newValue)
        }
        get {
            return self.font?.pointSize ?? UIFont.systemFontSize
        }
    }
}

public extension UIViewController {
    var toppestViewController: UIViewController {
        func toppestViewController(of viewController: UIViewController) -> UIViewController {
            if let navigationController = viewController as? UINavigationController, !navigationController.viewControllers.isEmpty {
                return toppestViewController(of: navigationController.viewControllers.last!)
            }
            
            if let tabBarController = viewController as? UITabBarController, let selectedController = tabBarController.selectedViewController {
                return toppestViewController(of: selectedController)
            }
            
            if let presentedController = viewController.presentedViewController {
                return toppestViewController(of: presentedController)
            }
            
            return viewController
        }
        
        return toppestViewController(of: self)
    }
    
    static var toppestViewController: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!.toppestViewController
    }
}

public extension UIButton {
    func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func removeTarget(_ target: Any?, action: Selector?) {
        self.removeTarget(target, action: action, for: .touchUpInside)
    }
}

public extension UIViewController {
    func present(animated: Bool, completion: (() -> Void)? = nil) {
        UIViewController.toppestViewController.present(self, animated: true, completion: completion)
    }
    
    func dismissSelf(animated: Bool = true) {
        self.presentingViewController?.dismiss(animated: animated, completion: nil)
    }
    
    func presentInsideNavigation(animated: Bool = true, completion: (() -> Void)? = nil) {
        let navigationController = AppNavigationController(rootViewController: self)
        let backButton = AppIconButton(image: Icon.arrowBack)
        backButton.addTarget(self, action: #selector(handleBack))
        self.navigationItem.leftViews = [backButton]
        
        navigationController.present(animated: animated, completion: completion)
    }
    
    @objc
    private func handleBack() {
        self.dismissSelf()
    }
}

public extension UIView {
    func prepareViews(_ views: [UIView], top: CGFloat = 20, height: CGFloat? = 40, widthInset: CGFloat? = 20, below: UIView? = nil, skipTopForFirst: Bool = false) {
        
        let first = views.first!
        prepareView(first, below: below, top: skipTopForFirst ? 0 : top, height: height, widthInset: widthInset)
        
        var toppest = first
        views.dropFirst().forEach {
            prepareView($0, below: toppest, top: top, height: height, widthInset: widthInset)
            toppest = $0
        }
    }
    
    func prepareView(_ view: UIView, below: UIView? = nil, top: CGFloat = 20, height: CGFloat? = 40, widthInset: CGFloat? = 20) {
        self.addView(view).makeConstraints { (make) in
            make.top.equalTo(below?.snp.bottom ?? self).offset(top)
            make.centerX.equalToSuperview()
            if let height = height {
                make.height.equalTo(height)
            }
            
            if let widthInset = widthInset{
                make.left.equalToSuperview().offset(widthInset)
                make.right.equalToSuperview().offset(-widthInset)
            }
        }
    }
}

public extension UICollectionView {
    func register<T: AppCollectionViewCell>(_ cellType: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: AppCollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

public extension UITableView {
    func register<T: AppTableViewCell>(_ cellType: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: AppTableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

public extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}

public extension UIImageView {
    convenience init(contentMode: UIViewContentMode) {
        self.init()
        self.contentMode = contentMode
    }
}


class Formatter {
    static var jsonDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter
    }()
}

public extension JSON {
    var urlValue: URL {
        return url ?? URL(fileURLWithPath: "")
    }
    
    var dateTime: Date? {
        return Formatter.jsonDateTimeFormatter.date(from: self.object as? String ?? "")
    }
    
    var dateTimeValue: Date {
        return dateTime ?? .distantFuture
    }
    
    var color: UIColor? {
        if let code = UInt32(String(self.stringValue.characters.dropFirst()), radix: 16) {
            return UIColor(rgb: code)
        }
        return nil
    }
    
    var colorValue: UIColor {
        return color ?? App.colors.primary
    }
}

public extension UIViewController {
    func navigate<T: UIViewController>(_ type: T.Type, before: (T) -> Void) {
        let vc = T()
        before(vc)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func navigate<T: UIViewController>(_ type: T.Type) {
        navigate(type) { _ in }
    }
    
    func navigateBack() {
        _ = self.navigationController!.popViewController(animated: true)
    }
}

public extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

public extension UIViewController {
    private class MessageView: AppView {
        static let shared = MessageView()
        
        let label: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.fontSize = 13
            return label
        }()
        
        lazy var closeButton: AppIconButton = {
            let button = AppIconButton(image: App.icons.close)
            button.addTarget(self, action: #selector(close))
            let padding: CGFloat = 4
            button.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            return button
        }()
        
        override func prepare() {
            super.prepare()
            self.addView(closeButton).makeConstraints {
                $0.right.bottom.equalToSuperview().offset(-4)
                $0.top.equalToSuperview().offset(4)
            }
            
            self.addView(label).makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.right.equalTo(closeButton.snp.right).offset(-8)
                $0.left.equalToSuperview().offset(8)
            }
            
            self.depthPreset = .depth1
            self.backgroundColor = App.colors.warning
            self.alpha = 0.9
        }
        
        func close() {
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height)
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    func showBanner(message: String) {
        guard let viewController = self.navigationController?.topViewController else {
            return
        }
        let msgView = MessageView.shared
        
        msgView.label.text = message
        viewController.view.addView(msgView).makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        
        let h = msgView.systemLayoutSizeFitting(viewController.view.bounds.size).height
        msgView.transform = CGAffineTransform(translationX: 0, y: -h)
        UIView.animate(withDuration: 0.25) { 
            msgView.transform = .identity
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(closeBanner), with: nil, afterDelay: 5)
    }
    
    func closeBanner() {
        MessageView.shared.close()
    }
    
    func showNoInternetBanner() {
        showBanner(message: App.strings.noInternet)
    }
    
    @discardableResult
    func showNoInternetBannerIfNeeded(_ err: ApiError?) -> Bool {
        if err?.isLocalError ?? false {
            showNoInternetBanner()
            return true
        }
        
        return false
    }
}
