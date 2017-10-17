//
//  AppLoadingOverlayView.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 10/11/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import RxSwift

open class AppLoadingOverlayView: AppView {
    open let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .darkGray
        return indicator
    }()
    
    private let container = UIView()
    
    open let label: UILabel = {
        let label = UILabel()
        label.fontSize = 23
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    open let button: UIButton = {
        class Button: UIButton {
            override var isHighlighted: Bool {
                didSet {
                    UIView.animate(withDuration: 0.2) {
                        self.alpha = self.isHighlighted ? 0.65 : 1
                    }
                }
            }
        }
        
        let button = Button()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.borderColor = UIColor.darkGray.cgColor
        let paddingLeftRight: CGFloat = 15
        let paddingTopBottom: CGFloat = 4
        button.contentEdgeInsets = UIEdgeInsets(top: paddingTopBottom, left: paddingLeftRight, bottom: paddingTopBottom, right: paddingLeftRight)
        return button
    }()
    
    open override func prepare() {
        super.prepare()
        isHidden = true
        backgroundColor = App.colors.background2

        self.addView(container).makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.78)
        }

        container.addView(label).makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        container.addView(button).makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.addView(indicator).makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    open let disposeBag = DisposeBag()
    open func show(title: String?, buttonTitle: String?, action: (() -> Void)?) {
        indicator.stopAnimating()
        container.isHidden = false
        label.text = title
        button.setTitle(buttonTitle, for: .normal)
        button.removeTarget(nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            action?()
        }).disposed(by: self.disposeBag)
        
        isHidden = false
    }
    
    open func showLoading() {
        indicator.startAnimating()
        container.isHidden = true
        isHidden = false
    }
    
    open func hide() {
        isHidden = true
    }
    
    open override var isHidden: Bool {
        didSet {
            if isHidden {
                indicator.stopAnimating()
                layer.zPosition = -10000
            } else {
                layer.zPosition = 10000
            }
        }
    }
}

public extension AppLoadingOverlayView {
    func noInternet(action: @escaping () -> Void) {
        self.show(title: App.strings.noInternet, buttonTitle: App.strings.tryAgain) {
            self.showLoading()
            action()
        }
    }
}
