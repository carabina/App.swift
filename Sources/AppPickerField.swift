//
//  AppPickerField.swift
//  LaundryApp
//
//  Created by Orkhan Alikhanov on 8/10/17.
//  Copyright © 2017 ATL Info Tech. All rights reserved.
//

import UIKit

open class AppPickerField: AppTextField {
    
    public enum `Type` {
        case string
        case date
    }
    
    open let type: Type
    open var isCaretHidden: Bool = true
    open var pickerData: [[String]] = [[]] {
        didSet {
            stringPicker.reloadAllComponents()
        }
    }
    
    open var selectedRow: Int {
        return stringPicker.selectedRow(inComponent: 0)
    }
    
    open override var text: String? {
        didSet {
            switch type {
            case .string:
                setCurrentRow()
            case .date:
                if let date = dateFormatter.date(from: text ?? "") {
                    datePicker.setDate(date, animated: false)
                }
            }
        }
    }
    public required init(type: Type = .string) {
        self.type = type
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
        super.prepare()
        prepareInputAccessoryView()
        self.inputView = {
            switch type {
            case .string:
                return stringPicker
            case .date:
                return datePicker
            }
        }()
    }
    
    open func prepareInputAccessoryView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor(rgb: 0x007aff)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(didTapCancel))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        inputAccessoryView = toolBar
    }
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        return isCaretHidden ? .zero : super.caretRect(for: position)
    }
    
    private var once = false
    open func setCurrentRow() {
        guard
            !once,
            let text = self.text,
            !text.isEmpty else { return }
        
        once = true
        let data = pickerData
        var indexes = [Int](repeating: 0, count: data.count)
        var upTo = ""
        var lastMatched = ""
        for (i, arr) in data.enumerated() {
            for (j, s) in arr.enumerated() {
                if text.hasPrefix(upTo + s) {
                    indexes[i] = j
                    lastMatched = upTo + s
                }
            }
            upTo = lastMatched
        }
        
        indexes.enumerated().forEach {
            stringPicker.selectRow($1, inComponent: $0, animated: false)
        }
    }
    
    open var didPressDone: (() -> Void)?
    open var labelFont = UIFont(name: "HelveticaNeue", size: 25)
    
    open lazy var stringPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    open lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter
    }()
    
    open let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    
    open func didTapDone() {
        switch type {
        case .date:
            self.text = dateFormatter.string(from: datePicker.date)
        case .string:
            var myText = ""
            for i in 0..<pickerData.count {
                let row = stringPicker.selectedRow(inComponent: i)
                myText += pickerData[i][row]
            }
            self.text = myText
        }
        
        didPressDone?()
        resignFirstResponder()
    }
    
    open func didTapCancel() {
        resignFirstResponder()
    }
    
    open override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if #available(iOS 10, *) {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return nil
            }
        } else {
            if action == #selector(paste(_:)) {
                return nil
            }
        }
        
        return super.target(forAction: action, withSender: sender)
    }
}

extension AppPickerField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel! = view as? UILabel
        if label == nil {
            label = UILabel()
            label.textColor = .black
            label.font = labelFont
            label.textAlignment = .center
        }
        
        label.text = pickerData[component][row]
        return label
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var width: CGFloat = 0
        let stringSizingAttributes = [NSFontAttributeName : self.labelFont!]
        pickerData[component].forEach {
            width = max(width, $0.size(attributes: stringSizingAttributes).width)
        }
        return width + 25
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        var height: CGFloat = 30
        if component < numberOfComponents(in: pickerView){
            let stringSizingAttributes = [NSFontAttributeName : self.labelFont!]
            pickerData[component].forEach {
                height = max(height, $0.size(attributes: stringSizingAttributes).height)
            }
        }
        return height
    }
}


