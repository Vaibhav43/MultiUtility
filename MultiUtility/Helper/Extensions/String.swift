//
//  String.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 10/04/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    var toData: Data?{
        return Data(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0))
    }
    
    var toInt: Int{
        return self.toNSString.integerValue
    }
    
    var toDouble: Double{
        return self.toNSString.doubleValue
    }
    
    var toCGFloat: CGFloat{
        return CGFloat(self.toNSString.doubleValue)
    }
    
    var toNSString: NSString{
        return NSString(string: self)
    }
    
    var unicode: String {
        guard let subString = self.components(separatedBy: "U+").first, let scalarValue = Int(subString), let scalar = UnicodeScalar(scalarValue) else { return "" }
        return String(Character(scalar))
    }
    
    var base64: String?{
        guard let data = self.data(using: .utf8) else {return nil}
        let base = data.base64EncodedString()
        return base
    }
    
    var base64ToString: String?{
        
        guard let data = Data(base64Encoded: self) else {return nil}
        guard let string = String(data: data, encoding: .utf8) else {return nil}
        
        return string
    }
    
    var validEmail: Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var validPassword: Bool{
        
        let passwordRegex:String = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!#$%&'*+,-./:;<=>?@|~]).{8,15}"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passTest.evaluate(with: self)
    }
    
    var isNumber: Bool{
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return (self == numberFiltered)
    }
    
    var toDictionary: NSDictionary? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(value: error.localizedDescription)
            }
        }
        return nil
    }
    
    var toDictArray: [NSDictionary]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
            } catch {
                print(value: error.localizedDescription)
            }
        }
        return nil
    }
    
    
    //MARK:- functions
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func callNumber() {
        
        if let phoneCallURL = URL(string: "tel://\(self)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func convertNextDate(format : String, next: Int) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let myDate = dateFormatter.date(from: self) else {return nil}
        let tomorrow = Calendar.current.date(byAdding: .day, value: next, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        
        return somedateString
    }
    
    //MARK:- validations
    
    func validNo(range: Int) -> Bool{
        return !(self.count < range)
    }
    
    func numberLimit(min: Int, max: Int) -> Bool{
        return (self.count < min || self.count > max)
    }
    
    func limit(string: String, range: NSRange, limit: Int) -> Bool{
        let currentCharacterCount = self.count
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= limit
    }
    
    func checkValue(valueType: ValueType) -> Bool{
        
        switch valueType {
        case .none:
            break // Do nothing
            
        case .onlyLetters:
            let characterSet = CharacterSet.letters
            if self.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
            
        case .onlyNumbers:
            let numberSet = CharacterSet.decimalDigits
            if self.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            
        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if self.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
            
        case .alphaNumeric:
            let alphaNumericSet = CharacterSet.alphanumerics
            if self.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }
            
        case .fullName:
            var characterSet = CharacterSet.letters
            print(characterSet)
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if self.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        
        return true
    }
    
    //MARK:- NSAttributed
    
    func strikeThrough(color: UIColor = .black) -> NSMutableAttributedString {
        
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: self.count))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: NSRange.init(location: 0, length: self.count))
        
        return attributeString
    }
    
    func attributed(fFont: UIFont = UIFont.systemFont(ofSize: 15),  fColor: UIColor = .black, second: String? = nil, sFont: UIFont = UIFont.systemFont(ofSize: 15), sAttribute: NSMutableAttributedString? = nil, sColor: UIColor = .black) -> NSAttributedString
    {
        let firstStringAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: fColor,
                                                                    NSAttributedString.Key.font: fFont,]
        
        let secondStringAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: sColor,
                                                                     NSAttributedString.Key.font: sFont,]
        
        let firstAttributedString = NSMutableAttributedString(string: self, attributes: firstStringAttribute)
        
        if second != nil{
            let secondAttributedString = NSMutableAttributedString(string: second!, attributes: secondStringAttribute)
            firstAttributedString.append(secondAttributedString)
        }
        else{
            sAttribute?.addAttributes(secondStringAttribute, range: NSRange.init(location: 0, length: (sAttribute?.length)!))
            firstAttributedString.append(sAttribute!)
        }
        
        
        return firstAttributedString
    }
    
    //MARK:- estimated
    
    func width(height: CGFloat, font: UIFont) -> CGFloat{
        
        let attributes = [NSAttributedString.Key.font: font]
        let size = NSString(string: self).boundingRect(with: CGSize(width: 1000, height: height), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return size.width+5
    }
    
    func height(width: CGFloat, font: UIFont) -> CGFloat{
        
        let attributes = [NSAttributedString.Key.font: font]
        let size = NSString(string: self).boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return size.height+5
    }
    
    //MARK:- substring
    
    func substring(from: Int, to: Int) -> String? {
        if from < to && to < self.count /*use string.characters.count for swift3*/{
            let startIndex = self.index(self.startIndex, offsetBy: from)
            let endIndex = self.index(self.startIndex, offsetBy: to)
            return String(self[startIndex..<endIndex])
        }else{
            return nil
        }
    }
    
    func subString(from: Int) -> String{
        return String(self.suffix(self.count-from))
    }
    
    func substring(to: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: 0)
        let end = self.index(self.startIndex, offsetBy: self.count)
        let substring = String(self[start..<end])
        return substring
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func subs_cript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

extension NSMutableAttributedString{
    
    func add(first: String, fFont: UIFont = UIFont.systemFont(ofSize: 15), fColor: UIColor = .black){
        
        let attributed = NSMutableAttributedString(string: first, attributes: [NSMutableAttributedString.Key.font: fFont, NSMutableAttributedString.Key.foregroundColor: fColor])
        self.append(attributed)
    }
}
