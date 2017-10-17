//
//  AppScrollViewController.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/12/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

open class AppScrollViewController: AppViewController {
    open var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    open let scrollView = UIScrollView()
    private let content = UIView()
    open override var contentView: UIView {
        return content
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScrollView()
        prepareContentView()
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: contentView, action:#selector(contentView.endEditing(_:))))
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    private var savedBottomInset: CGFloat = 0
    private var savedScrollIndicatorBottomInset: CGFloat = 0
    private var hasAlreadyAddedBottomInset = false

    @objc
    private func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                keyboardHeightLayoutConstraint.constant = 0.0
                if hasAlreadyAddedBottomInset {
                    scrollView.contentInset.bottom = savedBottomInset
                    scrollView.scrollIndicatorInsets.bottom = savedScrollIndicatorBottomInset
                    hasAlreadyAddedBottomInset = false
                }
            } else {
                keyboardHeightLayoutConstraint.constant = endFrame?.size.height ?? 0.0
                if !hasAlreadyAddedBottomInset {
                    savedBottomInset = scrollView.contentInset.bottom
                    savedScrollIndicatorBottomInset = scrollView.scrollIndicatorInsets.bottom
                    scrollView.contentInset.bottom = 2
                    scrollView.scrollIndicatorInsets.bottom = 2
                    hasAlreadyAddedBottomInset = true
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    open func prepareScrollView() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        keyboardHeightLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
        keyboardHeightLayoutConstraint.isActive = true
    }
    
    open func prepareContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
        }
    }
}
