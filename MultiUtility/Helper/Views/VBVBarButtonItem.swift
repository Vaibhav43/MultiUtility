//
//  VBVBarButtonItem.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 23/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVBarButtonItem: UIBarButtonItem {
    typealias ActionHandler = (UIBarButtonItem) -> Void
    
    private var actionHandler: ActionHandler?
    
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionHandler: ActionHandler?) {
        self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }
    
    convenience init(title: String?, style: UIBarButtonItem.Style, actionHandler: ActionHandler?) {
        self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, actionHandler: ActionHandler?) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }
    
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?(sender)
    }
}
