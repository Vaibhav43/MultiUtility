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
        
        let tabVC = AlarmTabViewController.initFromNib
        let navigation = UINavigationController(rootViewController: tabVC)
        return navigation
    }
    
    class func updateEntities(){
        
//        GlobalFunctions.Reminder.updateReminders()
    }
}
