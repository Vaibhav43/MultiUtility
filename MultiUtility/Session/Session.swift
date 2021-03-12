//
//  Session.swift
//  Alarm
//
//  Created by apple on 11/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class Session{
    
    static func initiate() -> UINavigationController{
        
        let vc = OptionsListViewController.initFromNib
        let navigation = UINavigationController(rootViewController: vc)
        return navigation
    }
    
    static func setSession(){
        
        AppDelegate.rootWindow?.rootViewController = Session.initiate()
        AppDelegate.rootWindow?.makeKeyAndVisible()
    }
}
