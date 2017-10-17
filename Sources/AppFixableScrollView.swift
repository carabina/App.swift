//
//  AppFixableScrollView.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 9/7/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

open class AppFixableScrollView: UIScrollView {
    open let topContainer = UIView()
    open let fixedContainer = UIView()
    open let bottomContainer = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
        
    open func prepare() {
        self.addView(topContainer).makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.width.equalToSuperview()
        }
        self.addSubview(bottomContainer)
        self.addSubview(fixedContainer)
    }
    
    
    open weak var scrollViewToChangeOffset: UIScrollView? {
        didSet {
            oldValue?.removeObserver(self, forKeyPath: "contentSize")
            scrollViewToChangeOffset?.isScrollEnabled = false
            scrollViewToChangeOffset?.showsVerticalScrollIndicator = false
            scrollViewToChangeOffset?.showsHorizontalScrollIndicator = false
            scrollViewToChangeOffset?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.bounds.width
        let h = self.bounds.height
        let y = self.contentOffset.y
        
        fixedContainer.bounds.size.width = w
        bottomContainer.bounds.size.width = w
        bottomContainer.frame.origin = .zero
        fixedContainer.frame.origin = .zero
        
        let top = topContainer.frame.maxY
        let mop = topContainer.frame.maxY + fixedContainer.frame.height
        
        if y >= top {
            fixedContainer.frame.origin.y = y // keep in vision.
            bottomContainer.frame.size.height = h - fixedContainer.frame.height
            
            //sroll inner scrollview.
            scrollViewToChangeOffset?.contentOffset.y = y - top
        } else {
            fixedContainer.frame.origin.y = topContainer.frame.maxY
            bottomContainer.frame.size.height = y + (h - mop)
            scrollViewToChangeOffset?.contentOffset.y = 0
        }
        
        
        bottomContainer.frame.origin.y = fixedContainer.frame.maxY //stick to bottom of fixedContainer, keep in vision.

        self.contentSize = CGSize(width: w, height: mop + (scrollViewToChangeOffset?.contentSize.height ?? 0))
    }

    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            layoutSubviews()
            return
        }
        
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    deinit {
        scrollViewToChangeOffset?.removeObserver(self, forKeyPath: "contentSize")
    }
}
