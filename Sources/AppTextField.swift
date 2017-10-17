//
//  AppTextField.swift
//  AppSwift
//
//  Created by Orkhan Alikhanov on 8/12/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Material

open class AppTextField: TextField, TextFieldDelegate {
    open var isErrorRevealed = false {
        didSet {
            detailLabel.isHidden = !isErrorRevealed
            layoutSubviews()
        }
    }

    open override func prepare() {
        super.prepare()
        self.placeholderVerticalOffset = 14
        self.dividerActiveColor = App.colors.primary
        self.placeholderActiveColor = App.colors.primary
        self.leftViewActiveColor = App.colors.primary
        
        
        isErrorRevealed = false
        detailLabel.textAlignment = .right
        detailVerticalOffset = 0.5
        detailColor = Color.red.base
        delegate = self
    }
    
    open func isValid(shouldChangeUI: Bool = true) -> Bool {
        return validator.isValid(self, shouldChangeUI: shouldChangeUI)
    }
    
    open let validator = Validator()
    open func textFieldDidEndEditing(_ textField: UITextField) {
        isErrorRevealed = false
    }
    
    open func textField(textField: TextField, didChange text: String?) {
        isErrorRevealed = false
    }
    
    open class Validator {
        public typealias ValidationBlock = (String) -> String?
        fileprivate var blocks: [ValidationBlock] = []
        
        open func isValid(_ textField: AppTextField, shouldChangeUI: Bool = true) -> Bool {
            for block in blocks {
                if let msg = block(textField.text ?? "") {
                    if shouldChangeUI {
                        textField.detailLabel.text = msg
                        textField.isErrorRevealed = true
                        textField.shake()
                    }
                    return false
                }
            }
            return true
        }
        
    }
}

public extension AppTextField.Validator {
    @discardableResult
    func notEmpty(msg: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
        let trimmingSet = trimmingSet ?? .init()
        return custom(msg: msg) {
            $0.trimmingCharacters(in: trimmingSet).isEmpty
        }
    }
    
    @discardableResult
    func email(msg: String) -> Self {
        return custom(msg: msg) {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return !emailTest.evaluate(with: $0)
        }
    }
    
    @discardableResult
    func min(length: Int, msg: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
        let trimmingSet = trimmingSet ?? .init()
        return custom(msg: msg) {
            $0.trimmingCharacters(in: trimmingSet).characters.count < length
        }
    }
    
    @discardableResult
    func noWhitespaces(msg: String) -> Self {
        return custom(msg: msg) {
            $0.rangeOfCharacter(from: .whitespaces) != nil
        }
    }
    
    @discardableResult
    func custom(msg: String, when block: @escaping (String) -> Bool) -> Self {
        self.blocks.append {
            block($0) ? msg : nil
        }
        return self
    }
}
