//
//  AddAlarmViewModel.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 14/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

protocol AlarmAddedDelegate {
    func alarmAdded(_ alarm: Reminder)
}

class AddAlarmViewModel{
    
    var delegate: AlarmAddedDelegate?
    var reloadTable: (() -> ())?
    var alarm: Reminder = Reminder.create()
    let cellArray: [(String, String)] = [("Title", "Enter Title"), ("Message", "Enter Message"), ("Tasks", "Select Task"), ("Alarm", "Select Time")]
    
    func saveAlarm(){
        
        alarm.created_time = Date()
        alarm.save()
        alarm.setReminder()
        delegate?.alarmAdded(alarm)
    }
    
    //MARK:- UI
    
    func showPicker(){
        
        let tasks = AlarmType.fetchString()
        VBVPickerView.shared.initiate(heading: "Select Type", titles: tasks) { (index) in
            guard let index = index else {return}
            self.alarm.task = tasks[index]
            self.reloadTable?()
        }
    }
    
    func showDate(){
        
        VBVDatePicker.shared.initiate(heading: "Select Reminder Date", mode: .dateAndTime, minimum: Date()) { (selectedDate) in
            guard let selectedDate = selectedDate else {return}
            self.alarm.reminder_time = selectedDate
            self.reloadTable?()
        }
    }
}
