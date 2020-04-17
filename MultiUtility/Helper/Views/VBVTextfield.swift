//
//  VBVTextfield.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 12/04/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

@objc protocol VBVTextfieldDelegate {
    
    @objc optional func textfieldShouldChange(_ textField: VBVTextfield, range: NSRange, string: String) -> Bool
    @objc optional func textfieldShouldBeginEditing(_ textField: VBVTextfield) -> Bool
    @objc optional func textfieldDidBeginEditing(_ textField: VBVTextfield)
    @objc optional func textfieldDidEndEditing(_ textField: VBVTextfield)
}


class VBVTextfield: UITextField{
    
    //MARK:- designable variables
    
    /// place holder color for the textfield using attributed
    @IBInspectable var placeHolderColor: UIColor = UIColor.lightGray{
        didSet{
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    fileprivate lazy var placeHolderLabel = UILabel()
    fileprivate lazy var placeHolderTextLayer = CATextLayer()
    @IBInspectable var showHeading = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    ///Max character length
    @IBInspectable var maxLength: Int = 0
    
    ///Accept only given character in string, this is case sensitive
    @IBInspectable var allowedCharInString: String = ""
    
    /// left image for the textfield
    @IBInspectable var leftImage : UIImage? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// right image of the textfield
    @IBInspectable var rightImage : UIImage? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    //MARK- Properties
    
    ///delegate for functions
    var vbvdelegate: VBVTextfieldDelegate?
    
    ///password hide text color
    var passwordHideTextColor: UIColor?
    
    ///password show text color
    lazy var passwordShowTextColor: UIColor = .black
    
    ///Allowed characters
    lazy var valueType: ValueType = ValueType.none
    
    ///password textfield image on the right, when text is shown
    var passwordSelectedImage: UIImage?
    
    ///password textfield image on the right, when text is hidden
    var passwordImage: UIImage?
    
    /// left padding for the textfield
    var insetX: CGFloat = 0{
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    /// right padding for the textfield
    var insetY: CGFloat = 0{
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    ///keyboard type according to the textfield
    var keyboard: Keyboard = .none{
        didSet{
            self.keyboardType = keyboard.type
            self.setNeedsDisplay()
        }
    }
    
    //MARK:- computed variables
    
    ///variable for class only
    fileprivate lazy var passwordButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(showPassword(_:)), for: .touchUpInside)
        button.setTitleColor(passwordShowTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(passwordHideTextColor, for: .selected)
        return button
    }()
    
    /// placeholder text
    override var placeholder: String?{
        didSet{
            self.doneButton()
        }
    }
    
    ///height for the left or right image mode
    var rightLeftModeHeight: CGFloat{
        return (self.frame.height > 25) ? 25 : self.frame.height
    }
    
    ///imageview containing the images for the left and right view
    var imageView: UIImageView = {
        
        let imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    /// for the left and right view modes where image can be set
    var imageContainer: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    //MARK:- lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setting()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        placeholderSet()
        setData()
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    //MARK:- Placeholder
    
    func placeholderSet(){
        
        guard showHeading, placeHolderLabel.text == nil, let holder = self.placeholder else{ return }
        placeHolderLabel.text = holder
        self.placeholder = nil
        placeHolderLabel.textColor = self.placeHolderColor
        placeHolderLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        placeHolderLabel.frame.origin = CGPoint(x: 3, y: -8)
        placeHolderLabel.frame.size = placeHolderLabel.intrinsicContentSize
        placeHolderLabel.backgroundColor = UIColor.white
        self.addSubview(placeHolderLabel)
        animatePlaceHolder()
    }
    
    fileprivate func animatePlaceHolder(){
        self.clipsToBounds = false
        if ((isEditing) || (!isEditing && !(self.text?.isEmpty ?? true))) && showHeading{
            UIView.animate(withDuration: 0.2) {
                self.placeHolderLabel.transform = .identity
            }
        }
        else{
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.placeHolderLabel.transform = CGAffineTransform(translationX: -5, y: self.frame.height*0.45)
            })
        }
    }
    
    //MARK:- setup
    
    fileprivate func setData(){
        
        if (keyboard == .password){
            resetImageMode()
            setPassword()
        }
        else if leftImage != nil || rightImage != nil{
            resetImageMode()
            setImage()
        }
    }
    
    /// setting the basic properties of the textfield
    fileprivate func setting(){
        self.doneButton()
        self.delegate = self
        self.borderStyle = .none
        self.clipsToBounds = true
        //        self.autocorrectionType = .no
        //        self.autocapitalizationType = .none
        //        self.smartDashesType = .no
        //        self.smartQuotesType = .no
        //        self.smartInsertDeleteType = .no
        //        self.spellCheckingType = .no
    }
    
    /// reset both left and right modes of textfield
    fileprivate func resetImageMode(){
        rightViewMode = .never
        leftViewMode = .never
        leftView = nil
        rightView = nil
    }
    
    /// setting image for a mode
    ///
    /// - Parameters:
    ///   - left: to set on left or right mode
    ///   - image: to show on mode
    fileprivate func setImageOn(left: Bool, image: UIImage) -> UIView{
        
        let width = rightLeftModeHeight
        let imageContain = imageContainer
        
        let imageV = imageView
        imageV.frame = CGRect(x: 5, y: 0, width: width, height: width)
        imageV.image = image
        let xFrame = (left) ? 0 : (self.frame.width-width-10)
        imageContain.frame = CGRect(x: xFrame, y: 0, width: width+10, height: width)
        imageContain.addSubview(imageV)
        
        return imageContain
    }
    
    ///set the left or right side of the image set on the variables
    fileprivate func setImage(){
        
        if let image = leftImage{
            leftViewMode = .always
            leftView = setImageOn(left: true, image: image)
        }
        
        if let image = rightImage{
            rightViewMode = .always
            rightView = setImageOn(left: false, image: image)
        }
    }
    
    //MARK: password field
    
    /// set the password properties of the textfield
    /// it can be with image or with text
    fileprivate func setPassword(){
        
        if keyboard == .password{
            
            let width = rightLeftModeHeight
            var buttonWidth: CGFloat = 50
            
            if let image = passwordImage{
                passwordButton.setImage(image, for: .normal)
                passwordButton.setImage(passwordSelectedImage, for: .selected)
                buttonWidth = width
                
            }else{
                passwordButton.setTitle("Show", for: .normal)
                passwordButton.setTitle("Hide", for: .selected)
            }
            
            let passwordframe = CGRect(x: self.frame.width-width, y: 4, width: buttonWidth, height: width)
            passwordButton.frame = passwordframe
            self.isSecureTextEntry = true
            self.rightViewRect(forBounds: passwordframe)
            self.rightView = passwordButton
            self.rightViewMode = .always
        }
        else{
            self.isSecureTextEntry = false
            passwordButton.removeFromSuperview()
        }
    }
    
    /// the action for the password button
    @objc func showPassword(_ sender: UIButton){
        sender.isSelected.toggle()
        self.isSecureTextEntry = !sender.isSelected
    }
}

/// delegate methods for the self protocol for the basic properties
extension VBVTextfield: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return vbvdelegate?.textfieldShouldBeginEditing?(self) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        vbvdelegate?.textfieldDidBeginEditing?(self)
//        animatePlaceHolder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        vbvdelegate?.textfieldDidEndEditing?(self)
//        animatePlaceHolder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /// if the typed text is not of defined value type
        if valueType != .none && !string.checkValue(valueType: valueType){
            return false
        }
        
        ///to check if the typed string is exceeding the range defined
        if let text = self.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }
        
        // Check supported custom characters
        if !self.allowedCharInString.isEmpty {
            let customSet = CharacterSet(charactersIn: self.allowedCharInString)
            if string.rangeOfCharacter(from: customSet.inverted) != nil {
                return false
            }
        }
        
        return vbvdelegate?.textfieldShouldChange?(self, range: range, string: string) ?? true
    }
}

extension VBVTextfield{
    
    func doneButton(){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.resignResponder))
        
        let placeholder: UILabel = {
            
            let label = UILabel()
            label.text = self.placeholder
            label.textColor = .lightGray
            return label
        }()
        
        let placeItem = UIBarButtonItem(customView: placeholder)
        let items = [flexSpace, placeItem, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func resignResponder(){
        self.resignFirstResponder()
    }
}
