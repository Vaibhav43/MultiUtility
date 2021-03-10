//
//  AlarmListViewModel.swift
//  Alarm
//
//  Created by apple on 12/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AlarmListViewModel: NSObject{
    
    //MARK:- Properties
    
    var recordsFetched: (()->())?
    var managedContext = CoreData.shared.persistentContainer.newBackgroundContext()
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<Reminder>()
    
    //MARK:- Delete
    
    var expired_count: Int{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        fetchRequest.predicate = NSPredicate(format: "reminder_time < %@", Date() as CVarArg)
        do {
            let count = try CoreData.shared.managedContext.count(for: fetchRequest)
            return count
        }
        catch {
            print(error.localizedDescription)
        }
        
        return 0
    }
    
    func showDeletePopUp(index: Int){
        
        UIApplication.topViewController?.alert(title: Messages.AlarmM.alarm, message: Messages.AlarmM.delete_alarm, defaultButton: "Yes", cancelButton: "No", completion: { (success) in
            
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
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetch_request(sort: [NSSortDescriptor(key: "reminder_time", ascending: true)], predicate: NSPredicate(format: "reminder_time >= %@", Date() as CVarArg), groupBy: nil)
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "task", cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
            recordsFetched?()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            recordsFetched?()
        }
    }
}
