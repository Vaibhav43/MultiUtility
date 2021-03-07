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
import UserNotifications


@objc(Reminder)
public class Reminder: NSManagedObject {
    
    func setReminder(){
        Notifications.shared.createReminder(reminder: self)
    }
}

extension Notifications{
    
    func createReminder(reminder: Reminder){
        
        let content = UNMutableNotificationContent()
        content.title = reminder.title ?? ""
        content.body = reminder.message ?? ""
        content.sound = UNNotificationSound(named: UNNotificationSoundName("breakTime.aiff"))
        
        guard let task = reminder.task else {return}
        content.categoryIdentifier = task
        
        guard let date = reminder.reminder_time else {return}
        
        let component = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: component, repeats: false)
        
        let millis = "\(reminder.created_time?.milliseconds ?? 0)"
        let request = UNNotificationRequest(identifier: task+millis, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }
}
