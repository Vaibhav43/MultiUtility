//
//  ExpiredAlarmViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ExpiredAlarmViewModal{
    
    //MARK:- Properties
    
    var managedContext = CoreData.shared.managedContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<Reminder>()
    
    func showDeletePopUp(index: Int){
        
        UIApplication.topViewController?.alert(title: Messages.Alarm.title, message: Messages.Alarm.delete, defaultButton: "Yes", cancelButton: "No", completion: { (success) in
            
            if success{
                guard let objects = self.fetchedResultController.fetchedObjects else {return}
                let objectAtIndex = objects[index]
                
                if let time = objectAtIndex.created_time?.milliseconds, let task = objectAtIndex.task{
                    Notifications.shared.remove(type: task+time.description)
                }
                
                objects[index].delete(context: self.managedContext)
            }
        })
    }
    
    //MARK:- fetch
    
    func fetchResults() {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetch_request(sort: [NSSortDescriptor(key: "reminder_time", ascending: true)], predicate: NSPredicate(format: "reminder_time < %@", Date() as CVarArg), groupBy: nil)
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "task", cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
