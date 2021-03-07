//
//  ColorConstant.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 13/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    struct Alarm{
        static let ktheme = UIColor.init(hex: "9CAFB7")
        static let kseparatorGrey = UIColor.init(hex: "f2f2f2")
        static let kappearance =  UIColor.init(hex: "#764134")
        static let ktext = UIColor.init(hex: "33658A")
    }

    struct Notes{
        
    }
    
    
    convenience init(hex:String) {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            cString = "808080"
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
