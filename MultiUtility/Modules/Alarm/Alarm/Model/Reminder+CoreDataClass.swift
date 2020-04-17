//
//  Reminder+CoreDataClass.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 17/04/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Reminder)
public class Reminder: NSManagedObject {

    func setReminder(){
        Notifications.shared.createReminder(reminder: self)
    }
}
