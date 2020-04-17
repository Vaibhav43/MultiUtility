//
//  VBVTextView.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 28/07/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import UIKit

@objc protocol VBVTextViewDelegate {
    
    @objc optional func textViewDidBeginEditing(_ textView: VBVTextView)
    @objc optional func textViewDidEndEditing(_ textView: VBVTextView)
}

class VBVTextView: UITextView {
    
    var vbvDelegate: VBVTextViewDelegate?
    
    /// Allowed characters
    var valueType: ValueType = .none
    
    ///when placeholder is shown previous color is saved for ending
    var previousTextColor: UIColor?
    
    /// padding
    var padding: UIEdgeInsets?{
        didSet{
            
            if let padding = padding{
                self.textContainerInset = padding
            }
        }
    }
    
    ///keyboard type according to the textfield
    var keyboard: Keyboard = .none{
        didSet{
            self.keyboardType = keyboard.type
        }
    }
    
    //MARK:- designable variables
    
    /// Max character length
    @IBInspectable var maxLength: Int = 0
    
    var showPlaceHolder = false
    
    ///text to show as placeholder
    @IBInspectable var placeHolder: String?{
        didSet{
            showPlaceHolder = true
        }
    }
    
    //MARK:- lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setting()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setPlaceHolder()
    }
    
    //MARK:- setup
    
    func setting(){
        self.delegate = self
        self.doneButton()
    }
    
    func setPlaceHolder(){
        
        if showPlaceHolder, let holder = placeHolder, self.text.isEmpty {
            self.text = holder
            self.previousTextColor = self.textColor
            self.textColor = UIColor.lightGray
        }
        else if let holder = placeHolder, self.text == holder{
            self.text = nil
            self.textColor = self.previousTextColor ?? UIColor.black
        }
        else{
            self.textColor = self.previousTextColor ?? UIColor.black
        }
    }
}

extension VBVTextView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        showPlaceHolder = false
        setPlaceHolder()
        vbvDelegate?.textViewDidBeginEditing?(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showPlaceHolder = true
        setPlaceHolder()
        vbvDelegate?.textViewDidEndEditing?(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if maxLength > 0{
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            if !(newText.count < maxLength){
                return false
            }
        }
        
        return text.checkValue(valueType: valueType)
    }
}

extension VBVTextView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                doneButton()
            }
        }
    }
    
    func doneButton(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.resignResponder))
    
        let items = [flexSpace, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func resignResponder(){
        self.resignFirstResponder()
    }
}
