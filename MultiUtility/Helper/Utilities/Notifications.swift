//
//  Notification.swift
//  VBVFramework
//
//  Created by apple on 24/06/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class Notifications: NSObject{
    
    struct Name {
    }
    
    static let shared = Notifications()
    let notificationCenter = UNUserNotificationCenter.current()
    var closure: (()->())?
    
    func set(name: String, completion: (()->())?){
        closure = completion
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(completionOfNotifcation),
            name: NSNotification.Name.init(name),
            object: nil)
    }
    
    func post(name: String){
        NotificationCenter.default.post(name: Notification.Name(name), object: nil)
    }
    
    @objc func completionOfNotifcation(){
        closure?()
        closure = nil
    }
}

extension Notifications{
    
    struct Identifiers{
        static let action = "Alarm Actions"
        static let identifier = "Local Notification"
        static let reset = "Reset"
        static let remove = "Remove"
        static let type = "Alarm"
        static let time = "time"
    }
    
    var scheduledTimeInterval: TimeInterval?{
        
        guard let date = UserDefaultsClass.get(key: .alarmTime) as? Date else{
            return nil
        }
        
        let interval = date.timeIntervalSince(Date())
        return (interval > 0) ? interval : nil
    }
    
    //MARK:- Setup
    
    func setup(){
        
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
    }
    
    func scheduleNotification(hour: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = Identifiers.type
        content.body = "You should take a break now. " + Identifiers.type
        content.sound = UNNotificationSound(named: UNNotificationSoundName("breakTime.aiff"))
        content.categoryIdentifier = Identifiers.action
        
        let timeInterval = hour*3600
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: Identifiers.identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: Identifiers.reset, title: Identifiers.reset, options: [])
        let deleteAction = UNNotificationAction(identifier: Identifiers.remove, title: Identifiers.remove, options: [.destructive])
        let category = UNNotificationCategory(identifier: Identifiers.action, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        let date = Date().generate(addbyUnit: .second, value: timeInterval)
        UserDefaultsClass.save(key: .alarmTime, value: date)
        notificationCenter.setNotificationCategories([category])
    }
    
    //MARK:- Reset
    
    func reset(){
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaultsClass.delete(key: .alarmTime)
    }
}

extension Notifications{
    
    func createReminder(reminder: Reminder){
        
        let content = UNMutableNotificationContent()
        content.title = reminder.title ?? ""
        content.body = reminder.message ?? ""
        content.sound = UNNotificationSound(named: UNNotificationSoundName("abc.aiff"))
        
        
        if let task = reminder.task{
            content.categoryIdentifier = task
            
            switch AlarmType(rawValue: task.lowercased()) {
                
            case .reminder:
                
                if let date = reminder.reminder_time{
                    
                    let component = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: component, repeats: false)
                    let request = UNNotificationRequest(identifier: task, content: content, trigger: trigger)
                    
                    notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
                
            default:
                break
            }
        }
    }
}

extension Notifications: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard response.notification.request.identifier == Identifiers.identifier else {
            completionHandler()
            return
        }
        
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
            
        case UNNotificationDefaultActionIdentifier:
            print("Default")
            
        case Identifiers.reset:
            scheduleNotification(hour: 1)
            
        case Identifiers.remove:
            reset()
            
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
}
