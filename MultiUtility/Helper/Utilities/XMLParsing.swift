//
//  XMLParsing.swift
//  VBVFramework
//
//  Created by Evolko iOS on 12/26/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation

class XMLParsing: NSObject, XMLParserDelegate{
    
    var xmlCharacter: String?
    var completion: ((NSMutableArray)->())?
    var firstDict = NSMutableDictionary()
    var dataArray = NSMutableArray()
    let elementArray = [""]
    
    func xmlParsing(xml: String, completion: ((NSMutableArray)->())?){
        
        self.completion = completion
        dataArray = NSMutableArray()
        let data: Data? = xml.data(using: .utf8)
        
        //initiate  NSXMLParser with this data
        let parser: XMLParser? = XMLParser(data: data ?? Data())
        //setting delegate
        parser?.delegate = self
        //call the method to parse
        parser?.parse()
        parser?.shouldResolveExternalEntities = true
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        xmlCharacter = elementName
        if elementArray.contains(elementName){
            firstDict = NSMutableDictionary()
        }
    }
    
   
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementArray.contains(elementName){

            if firstDict.count > 0{
                dataArray.add(firstDict)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if let xml = xmlCharacter{
            firstDict.setValue(string, forKey: xml)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        xmlCharacter = nil
        completion?(dataArray)
    }
}
