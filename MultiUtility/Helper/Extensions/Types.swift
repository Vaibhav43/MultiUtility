//
//  Types.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 21/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Int{
    
    static func parse(from string: String?) -> Int? {
        
        if let string = string{
            let values = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            return values.joined().toInt
        }
        
        return nil
    }
}

extension Dictionary where Key == String{
    
    
    func bool(for key: String) -> Bool{
        
        if let bool = self[key] as? Bool{
            return bool
        }
        else if let id = self[key] as? NSString{
            return id.boolValue
        }
        else if let id = self[key] as? NSNumber{
            return id.boolValue
        }
        else if let value = self.string(for: key), value.lowercased() == "yes"{
            return true
        }
        
        return false
    }
    
    func url(for key: String) -> URL?{
        
        if let value = self.string(for: key), let url = URL(string: value){
            return url
        }
        
        return nil
    }
    
    func string(for key: String) -> String?{
        
        if let value = self[key] as? String{
            return value
        }
        else if let value = self[key] as? Int{
            return "\(value)"
        }
        else if let value = self[key] as? NSNumber{
            return value.stringValue
        }
        else if let value = self[key] as? Double{
            return "\(value)"
        }
        
        return nil
    }
    
    func nsNumber(for key: String) -> NSNumber?{
        
        if let id = self[key] as? NSString{
            return id.integerValue as NSNumber
        }
        else if let id = self[key] as? Int{
            return id as NSNumber
        }
        
        return nil
    }
    
    func int(for key: String) -> Int?{
        
        if let id = self[key] as? NSString{
            return id.integerValue
        }
        else if let id = self[key] as? Int{
            return id
        }
        
        return nil
    }
    
    func int64(for key: String) -> Int64?{
        
        if let id = self[key] as? NSString{
            return id.longLongValue
        }
        else if let id = self[key] as? Int64{
            return id
        }
        
        return nil
    }
    
    func double(for key: String) -> Double?{
        
        if let id = self[key] as? NSString{
            return id.doubleValue
        }
        else if let id = self[key] as? Double{
            return id
        }
        else if let id = self[key] as? NSNumber{
            return id.doubleValue
        }
        return nil
    }
}

extension Int64{
    
    var milliSecondToDate: Date{
        return Date(timeIntervalSince1970: (TimeInterval(self / 1000)))
    }
}

extension Double {
    
    var finiteValue: Double{
        return self.isNaN ? 0 : self
    }
    
    var feet: Double{
        let value = (self/30.48)
        return floor(value)
    }
    
    var inch: Double{
        
        let remainder = self-(feet*30.48)
        let inch = remainder/2.54
        return floor(inch)
    }
    
    var toString: String{
        return "\(self)"
    }
    
    var toInt: Int{
        return Int(self)
    }
    
    var roundToNearest: Double{
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    var removeDecimal: String{
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        // Avoid not getting a zero on numbers lower than 1
        // Eg: .5, .67, etc...
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? "0"
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat{
    
    var finiteValue: CGFloat{
        return self.isNaN ? 0 : self
    }
    
    var roundedToLower100: CGFloat{
        
        var value = self
        let remainder = value.truncatingRemainder(dividingBy: 100)
        
        if remainder != 0{
            value -= (remainder)
        }
        
        return value
    }
    
    var roundedToUpper100: CGFloat{
        
        var value = self
        let remainder = value.truncatingRemainder(dividingBy: 100)
        if remainder != 0{
            value += (100 - remainder)
        }
        
        return value
    }
    
    var roundToNearest: CGFloat{
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    var removeDecimal: String{
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        // Avoid not getting a zero on numbers lower than 1
        // Eg: .5, .67, etc...
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? "0"
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Data {
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    var toNSData: NSData{
        return NSData(data: self)
    }
    
    var toBytes8: [UInt8]{
        return [UInt8] (self)
    }
    
    var toBytes64: [Int64]{
        
        let value: [Int64] = self.withUnsafeBytes {
            $0.load(as: [Int64].self)
        }
        return value
    }
    
    var image: UIImage?{
        
        if let image = self.toBytes8.toImage{
            return image
        }
        
        return nil
    }
}

extension TimeInterval {
    
    var milliseconds: Int {
        let truncated = (truncatingRemainder(dividingBy: 1))
        return Int(truncated * 1000)
    }
    
    var seconds: Int {
        return Int(self) % 60
    }
    
    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
