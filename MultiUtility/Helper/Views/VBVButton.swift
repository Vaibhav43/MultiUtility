//
//  UIButton.swift
//  VBVFramework
//
//  Created by Evolko iOS on 1/25/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVButton: UIButton{
    
    //MARK:- properties
    
    typealias ActionHandler = ((VBVButton) -> ())
    private var actionHandler: ActionHandler?
    
    var selectedTintColor: UIColor = .clear
    var unSelectedTintColor: UIColor = .clear
    
    override var isSelected: Bool {
        willSet {
        }
        
        didSet {
            self.tintColor = (isSelected) ? selectedTintColor : unSelectedTintColor
        }
    }
    
    //MARK:- lifecycle
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- setup
    
    init(image: String? = nil, title: String? = nil, color: UIColor = .blue, state: UIControl.State = .normal, action: ((VBVButton) -> ())?) {
        super.init(frame: .zero)
        configuration(image: image, title: title, color: color, state: state, action: action)
    }
    
    func configuration(image: String? = nil, title: String? = nil, color: UIColor = .blue, state: UIControl.State = .normal, action: ((VBVButton) -> ())?){
        
        if let image = image{
            rendered(image: image, color: color, state: state)
        }
        
        if let title = title{
            set(title: title, color: color, state: state)
        }
        
        addTarget(self, action: #selector(actionClicked(_:)), for: .touchUpInside)
        actionHandler = action
    }
    
    //MARK:- button handling
    
    @objc private func actionClicked(_ sender: VBVButton) {
        self.actionHandler?(sender)
    }
}

extension VBVButton{
    
    func set(title: String?, color: UIColor, state: UIControl.State){
        self.setTitle(title, for: state)
        self.setTitleColor(color, for: state)
    }
    
    func setTint(selected: UIColor, unselected: UIColor){
        self.selectedTintColor = selected
        self.unSelectedTintColor = unselected
    }
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
    func alignment(edge: UIRectEdge){
        
        guard let width = imageView?.frame.width else{ return }
        
        let boundWith = (bounds.width - 35)
        let imageWidth = width - 10
        let isRight = edge == .right
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: isRight ? 5 : boundWith, bottom: 0, right: isRight ? boundWith : 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: isRight ? imageWidth : 0, bottom: 0, right: isRight ? imageWidth : 0)
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
    }
    
    func rendered(image: String, color: UIColor = UIColor.custom_appearance, state: UIControl.State = .normal){
        
        guard let img = UIImage(named: image) else {return}
        
        let newImage = img.withRenderingMode(.alwaysTemplate)
        (state == .selected) ? (self.selectedTintColor = color) : (self.unSelectedTintColor = color)
        self.setImage(newImage, for: state)
        self.tintColor = color
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
}
