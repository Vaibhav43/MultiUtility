//
//  API.swift
//
//
//  Created by Vaibhav Agarwal on 23/07/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation


enum Image: String{
    
    case thumb
    case full
}

struct EndPoint {
    
}

let MAIN_URL = ""//dev
//let MAIN_URL = ""//prod


//var manager = Alamofire.SessionManager()

class API{
    
    //    class func put(endPoint: String, showLoader: Bool = true, parameters: NSMutableDictionary, completion: ((DataResponse<Any>) -> (Void))?){
    //
    //        if !Reachability.isConnectedToNetwork(){
    //            Constant.hideLoader()
    //            Toast.show(message: Messages.NO_INTERNET)
    //            return
    //        }
    //
    //        guard let param = makeJSONRequest(request: parameters) as? Global.TypeAlias.dictionary else {return}
    //
    //        let headers = [
    //            "Content-Type": "application/json"
    //        ]
    //
    //        if showLoader{
    //            Constant.showLoader()
    //        }
    //
    //        let url = MAIN_URL+endPoint
    //
    //        print(value:"URL ======== \(url)")
    //
    //        manager.session.configuration.timeoutIntervalForRequest = 30
    //        manager.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
    //            Constant.hideLoader()
    //
    //            if "\(response)".count < 2000{
    //                print(value: response.value ?? "")
    //            }
    //
    //            switch response.result{
    //
    //            case .success:
    //                completion!(response)
    //
    //            case .failure:
    //                print(value:"FAILED======\(url) \n\n \(param)")
    //                Toast.show(message: Messages.PLEASE_TRY_AGAIN)
    //            }
    //        }
    //    }
    
    
    //    class func get(endPoint: String, completion: ((DataResponse<Any>) -> (Void))?){
    //
    //        if !Reachability.isConnectedToNetwork(){
    //            Toast.show(message: Messages.NO_INTERNET)
    //            return
    //        }
    //
    //        let headers = [
    //            "Content-Type": "application/json"
    //        ]
    //        Constant.showLoader()
    //        let url = MAIN_URL + endPoint
    //        print(value:"URL ========= \(url)")
    //
    //        manager.session.configuration.timeoutIntervalForRequest = 30
    //        manager.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
    //            Constant.hideLoader()
    //            print(value: response)
    //
    //            switch response.result{
    //
    //            case .success:
    //                completion!(response)
    //
    //            case .failure:
    //                Toast.show(message: Messages.PLEASE_TRY_AGAIN)
    //            }
    //        }
    //    }
    
    
    
    //    class func multiPart(endPoint: String, showLoader: Bool = true, parameters: NSMutableDictionary, data: Data?, key: String , completion: ((DataResponse<Any>) -> (Void))?){
    //
    //        if !Reachability.isConnectedToNetwork(){
    //            Constant.hideLoader()
    //            Toast.show(message: Messages.NO_INTERNET)
    //            return
    //        }
    //
    //        let headers = [
    //            "Content-Type": "application/json"
    //        ]
    //
    //        if showLoader{
    //            Constant.showLoader()
    //        }
    //
    //        let url = MAIN_URL+endPoint
    //        print(value:"URL ======== \(url)")
    //
    //        manager.session.configuration.timeoutIntervalForRequest = 30
    //        manager.upload(multipartFormData: { (multipart) in
    //
    //            if data != nil{
    //                multipart.append(data!, withName: key, fileName: key+".jpg",mimeType: "image/jpg")
    //            }
    //
    //            for keys in parameters.allKeys{
    //
    //                if let key = keys as? String, let str = parameters.stringValue(key: key), let converted = str.data(using: .utf8){
    //                    multipart.append(converted, withName: key)
    //                }
    //            }
    //
    //        }, usingThreshold: 1, to: url, method: .put, headers: headers) { (result) in
    //
    //            switch result {
    //            case .success(let upload, _ , _):
    //
    //                upload.uploadProgress(closure: { (progress) in
    //                    print(value:"uploading")
    //                })
    //
    //                upload.responseJSON { response in
    //                    Constant.hideLoader()
    //                    completion!(response)
    //                    print(value: "done")
    //                }
    //
    //            case .failure(let encodingError):
    //                print(value: "failed")
    //                print(value: encodingError)
    //                Constant.hideLoader()
    //                Toast.show(message: Messages.PLEASE_TRY_AGAIN)
    //                return
    //            }
    //        }
    //    }
    
    //MARK:- conversion data
    
    // Convert from NSData to json object
    class func nsdataToJSON(data: Data) -> Any? {
        do {
            
            return try JSONSerialization.jsonObject(with: data , options: .mutableContainers)
        } catch let myJSONError {
            print(value: myJSONError)
        }
        return nil
    }
    
    // Convert from JSON to nsdata
    class  func jsonToNSData(json: AnyObject) -> Data?{
        do {
            
            return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let myJSONError {
            print(value: myJSONError)
        }
        return nil;
    }
    
    class func makeJSONRequest(request: Global.TypeAlias.dictionary) -> Global.TypeAlias.dictionary {
        
        let param = request
        
        //  print(value: "---------------- %@ ----------------",param)
        var jsonData = Data ()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            let str = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            
            if str?.length ?? 0 < 2000{
                print(value: "REQUEST_JSON ------------------> \(str!)")
            }
            
        }catch let err {
            print(value: err.localizedDescription)
        }
        
        return param
    }
}
