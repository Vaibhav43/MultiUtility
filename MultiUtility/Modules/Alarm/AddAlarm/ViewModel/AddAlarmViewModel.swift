//
//  AddAlarmViewModel.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 14/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddAlarmViewModel{
    
    //MARK:- Properties
    
    var managedContext = CoreData.shared.managedContext.newContext(mergeWithParent: true)
    var reloadTable: (() -> ())?
    var alarm: Reminder?
    let cellArray: [(String, String)] = [("Title", "Enter Title"), ("Message", "Enter Message"), ("Tasks", "Select Task"), ("Alarm", "Select Time")]
    
    //MARK:- setup
    
    func initialize(){
        alarm = Reminder.create(context: managedContext)
    }
    
    //MARK:- Save
    
    func saveAlarm(){
        
        alarm?.created_time = Date()
        managedContext.saveContext()
        alarm?.setReminder()
    }
    
    //MARK:- UI
    
    func showPicker(){
        
        let tasks = AlarmType.fetchString()
        VBVPickerView.shared.initiate(heading: "Select Type", titles: tasks) { (index) in
            guard let index = index else {return}
            self.alarm?.task = tasks[index]
            self.reloadTable?()
        }
    }
    
    func showDate(){
        
        VBVDatePicker.shared.initiate(heading: "Select Reminder Date", mode: .dateAndTime, minimum: Date(), date: alarm?.reminder_time) { (selectedDate) in
            guard let selectedDate = selectedDate else {return}
            let newDate = Calendar.current.date(bySetting: .second, value: 0, of: selectedDate)
            self.alarm?.reminder_time = newDate
            self.reloadTable?()
        }
    }
}
