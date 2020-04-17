//
//  Conversion.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 25/02/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//

import Foundation

struct Conversion {
      
      static func string(modal: Any) -> String?{
          
          let dict = dictionary(modal: modal)
          let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
          let decoded = String(data: jsonData, encoding: .utf8)
          return decoded
      }
      
      static func string(modal: [Any]) -> String?{
          
          var dictArray = [Global.TypeAlias.dictionary]()
          
          modal.forEach { (new) in
              dictArray.append(dictionary(modal: new))
          }
          
          let string = dictArray.toString
          return string
      }
      
      static func arrayToDictionary(modal: [Any]) -> [Global.TypeAlias.dictionary]{
          
          var array = [Global.TypeAlias.dictionary]()
          
          modal.forEach { (new) in
              
              let dict = dictionary(modal: new)
              array.append(dict)
          }
          
          return array
      }
      
      static func dictionary(modal: Any) -> Global.TypeAlias.dictionary{
          
          let mirror = Mirror(reflecting: modal)
          
          if mirror.children.isEmpty{
              return Global.TypeAlias.dictionary()
          }
          
          return parseToDictionary(mirror: mirror)
      }
      
      static func parseToDictionary(mirror: Mirror) -> Global.TypeAlias.dictionary{
          
          var request = Global.TypeAlias.dictionary()
          
          for child in mirror.children{
              
              guard let label = child.label else{ continue }
              
              if let value = child.value as? [Any]{
                  let dictionary = arrayToDictionary(modal: value)
                  request[label] = dictionary
              }
              else {
                  
                  let mirror = Mirror(reflecting: child.value)
                  
                  if !mirror.children.isEmpty{
                      let dict = dictionary(modal: child.value)
                      
                      if dict.count != 0{
                          request[label] = dict
                      }
                      
                  }
                  else{
                      request[label] = child.value
                  }
              }
          }
          
          return request
      }

}
