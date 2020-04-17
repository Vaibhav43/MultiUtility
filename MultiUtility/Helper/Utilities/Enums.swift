//
//  Enums.swift
//  VBVFramework
//
//  Created by Vaibhav Agarwal on 13/11/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

enum Path: String{
    case internalFolder = ".InternalFolder"
}

enum UploadType: String{
    case documents
    case profile_image
}

enum CellType{
    
    case submit
    case text
    case number
    case email
}

enum TableCells: String{
    case none = ""
}

enum CollectionCells: String {
    case none = ""
}

/**
 Used for corner radius on the layer of a view
 
 - rounded: for a completely rounded view. Radius = height*0.5
 - light: for a light rounded view. Radius = height*0.15
 - semiRounded: for a semi rounded view. Radius = height*0.25
 - none: Radius = 0
 */

enum ValueType: Int {
    case none
    case onlyLetters
    case onlyNumbers
    case phoneNumber   // Allowed "+0123456789"
    case alphaNumeric
    case fullName       // Allowed letters and space
}

/**
 Used for corner radius on the layer of a view
 
 - rounded: for a completely rounded view. Radius = height*0.5
 - light: for a light rounded view. Radius = height*0.15
 - semiRounded: for a semi rounded view. Radius = height*0.25
 - none: Radius = 0
 */

@objc enum CornerRadius: Int{
    
    /// for a completely rounded view. Radius = height*0.04
    case mild
    
    /// for a completely rounded view. Radius = height*0.1
    case semiLight
    
    /// for a completely rounded view. Radius = height*0.5
    case rounded
    
    /// for a light rounded view. Radius = height*0.15
    case light
    
    /// for a semi rounded view. Radius = height*0.25
    case semiRounded
    
    case none
    
    func cornered(view: UIView) -> CGFloat{
        
        switch self {
            
        case .mild:
            return view.frame.height*0.04
            
        case .semiLight:
            return view.frame.height*0.1
            
        case .rounded:
            return view.frame.height*0.5
            
        case .light:
            return view.frame.height*0.15
            
        case .semiRounded:
            return view.frame.height*0.25
            
        default:
            return 0
        }
    }
}


enum Keyboard{
    
    case number
    case email
    case password
    case otp
    case text
    case none
    
    var type: UIKeyboardType{
        
        switch self {
        case .number, .otp:
            return .numberPad
            
        case .email:
            return .emailAddress
            
        default:
            return .asciiCapable
        }
    }
}

enum AlarmType: String{
    
    case timeBreak
    case reminder
    case task
    
    static func fetchString() -> [String]{
        return [timeBreak.rawValue.capitalized, reminder.rawValue.capitalized, task.rawValue.capitalized]
    }
}
