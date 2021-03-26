//
//  SeparatorLabel.swift
//  VBVFramework
//
//  Created by Vaibhav Agarwal on 29/11/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit

@IBDesignable class VBVLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    var canCopy: Bool = false{
        didSet{
            setupCopy()
        }
    }
    
    //MARK:- lifecycle
    
    override func drawText(in rect: CGRect) {
        var newRect = rect
        
        switch contentMode {
            
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
            
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
            
        default:
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            newRect = rect.inset(by: insets)
        }
        
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    //MARK:- copy functioanlity
    
    func setupCopy(){
        
        if canCopy{
            self.isUserInteractionEnabled = true
            addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showCopyMenu(sender:))))
        }
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
//        UIMenuController.shared.showMenu(from: sender, rect: sender.)
    }
    
    @objc func showCopyMenu(sender: Any?) {
        becomeFirstResponder()
        let menuController = UIMenuController.shared
        
        if !menuController.isMenuVisible {
//            menuController.setTargetRect(bounds, in: self)
//            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        /// for all menu use true
        ///for copy only user action
        return true//(action == #selector(copy(_:)))
    }

    @objc internal func onMenu1(sender: UIMenuItem) {
        print("onMenu1")
    }

    @objc internal func onMenu2(sender: UIMenuItem) {
        print("onMenu2")
    }

    @objc internal func onMenu3(sender: UIMenuItem) {
        print("onMenu3")
    }
}

extension VBVLabel{
    
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
