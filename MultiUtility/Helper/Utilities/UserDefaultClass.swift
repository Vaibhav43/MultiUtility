//
//  UserDefaultClass.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 14/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation


let userDefault = UserDefaults.standard

class UserDefaultsClass{
    
    enum UDKeys: String {
        case alarmTime = "alarmTime"
    }
    
    class func save(key: UDKeys, value: Any){
        userDefault.set(value, forKey: key.rawValue)
    }
    
    class func get(key: UDKeys) -> Any?
    {
        if let value = userDefault.value(forKey: key.rawValue){
            return value
        }
        
        return nil
    }
    
    class func delete(key: UDKeys){
        
        if let _ = userDefault.value(forKey: key.rawValue){
            userDefault.removeObject(forKey: key.rawValue)
        }
    }
    
    class func isAvailable(key: UDKeys) -> Bool
    {
        return !(userDefault.value(forKey: key.rawValue) == nil)
    }
    
    class func clearAll(){
        
        if let identifier = Bundle.main.bundleIdentifier{
            userDefault.removePersistentDomain(forName: identifier)
            userDefault.synchronize()
        }
    }
}
