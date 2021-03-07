//
//  VBVPickerView.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 15/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class VBVPickerView: UIView{
    
    //MARK:- Instance
    
    private static var privateShared: VBVPickerView?
    
    class var shared: VBVPickerView { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = VBVPickerView()
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
    
    //MARK:- Variables
    
    var heading: String?
    var toolBar = UIToolbar()
    var pickerView = UIPickerView()
    var titles = [String]()
    var completion: ((Int?)->())?
    
    //MARK:- lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup
    
    func initiate(heading: String?, titles: [String], completion: @escaping ((Int?)->())) {
        self.titles = titles
        self.completion = completion
        self.heading = heading
        showPicker()
    }
    
    func setToolBar(){
        
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.custom_appearance
        toolBar.sizeToFit()
    }
    
    func setActionOnToolBar(){
        
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
        self.addSubview(pickerView)
        self.addSubview(toolBar)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: topController.view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: topController.view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: topController.view.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: topController.view.frame.height*0.45)
        ])
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        NSLayoutConstraint.activate([
            toolBar.heightAnchor.constraint(equalToConstant: 50),
            toolBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolBar.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 5),
        ])
        
        setActionOnToolBar()
    }
    
    func removePicker(){
        
        pickerView.removeFromSuperview()
        self.removeFromSuperview()
        self.pickerView.delegate = nil
        VBVPickerView.destroy()
    }
    
    //MARK:- Actions
    
    @objc func doneClicked(){
        let index = self.pickerView.selectedRow(inComponent: 0)
        completion?(index)
        removePicker()
    }
    
    @objc func cancelClicked(){
        completion?(nil)
        removePicker()
    }
}

extension VBVPickerView: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
