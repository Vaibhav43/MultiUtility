//
//  Structures.swift
//  VBVFramework
//
//  Created by Vaibhav Agarwal on 29/10/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

struct Messages {
    
    static let NO_INTERNET = "Check your internet connection."
    static let PLEASE_TRY_AGAIN = "Please try again."
    static let LOCATION_NOT_ALLOWED = "Dear User, you have not been registered as you have denied the request to access location."
    
    struct Alarm {
        static let title = "Alarm"
        static let delete = "Are you sure you want to delete the alarm?"
    }
    
    struct Notes{
        static let title = "Notes"
        static let delete = "Are you sure you want to delete this note?"
    }
}

struct Global {
    static let debug = true
    
    struct TypeAlias {
       typealias dictionary = Dictionary<String, Any>
    }
}

struct Symbol {
    
    static let degree = "\u{00B0}"
    static let currency = "\u{20B9}"
}
