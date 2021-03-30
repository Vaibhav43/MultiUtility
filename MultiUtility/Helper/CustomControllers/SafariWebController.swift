//
//  SafariWebController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 30/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import SafariServices

class SafariWebController: NSObject, SFSafariViewControllerDelegate{
    
    //MARK:- Instance
    
    ///picker reference for the image picker
    fileprivate var picker: SafariWebController?
    
    private static var privateShared: SafariWebController?
    
    class var shared: SafariWebController { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = SafariWebController()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    private override init() {
        super.init()
    }
    
    var safari: SFSafariViewController?
    
    //MARK:- safari functions
    
    func showSafari(url: URL?){
        
        guard let url = url, safari == nil, let topController = UIApplication.topViewController else { return }
        
        safari = SFSafariViewController(url: url)
        safari?.delegate = self
        topController.present(safari!, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        safari = nil
        SafariWebController.destroy()
    }
}
