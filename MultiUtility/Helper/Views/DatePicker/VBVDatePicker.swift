//
//  VBVDatePicker.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 16/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class VBVDatePicker: UIView{
    
    //MARK:- Instance
    
    private static var privateShared: VBVDatePicker?
    
    class var shared: VBVDatePicker { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = VBVDatePicker()
            return privateShared!
        }
        return uwShared
    }
    
    private init() {
        super.init(frame: .zero)
    }
    
    deinit {
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    //MARK:- Variable
    
    var heading: String?
    var toolBar = UIToolbar()
    var datePicker = UIDatePicker()
    var completion: ((Date?) -> ())?
    
    
    //MARK:- lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup
    
    func initiate(heading: String?, mode: UIDatePicker.Mode, minimum: Date? = nil, maximum: Date? = nil, date: Date? = nil, completion: @escaping ((Date?) -> ())) {
        
        self.completion = completion
        self.heading = heading
        self.datePicker.date = date ?? Date()
        self.datePicker.datePickerMode = mode
        self.datePicker.minimumDate = minimum
        self.datePicker.maximumDate = maximum
        showPicker()
    }
    
    func setToolBar(){
        
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.custom_appearance
        toolBar.sizeToFit()
    }
    
    func setActionOnToolbar(){
        
        toolBar.layoutIfNeeded()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let headingButton = UIBarButtonItem(title: heading ?? "", color: .lightGray, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelClicked))
        toolBar.setItems([cancelButton, spaceButton, headingButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    func showPicker(){
        setToolBar()
        guard let topController = UIApplication.topViewController else{return}
        topController.view.addSubview(self)
        self.addSubview(datePicker)
        self.addSubview(toolBar)
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: topController.view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: topController.view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: topController.view.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: topController.view.frame.height*0.4)
        ])
        
        NSLayoutConstraint.activate([
            toolBar.heightAnchor.constraint(equalToConstant: 50),
            toolBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolBar.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
        ])
        
        setActionOnToolbar()
    }
    
    func removePicker(){
        
        datePicker.removeFromSuperview()
        self.removeFromSuperview()
        VBVDatePicker.destroy()
    }
    
    //MARK:- Actions
    
    @objc func doneClicked(){
        completion?(datePicker.date)
        removePicker()
    }
    
    @objc func cancelClicked(){
        completion?(nil)
        removePicker()
    }
}
