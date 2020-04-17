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
    
    var managedContext = CoreData.shared.createNewContext(mergeWithParent: true)
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<Reminder>()
    
    //MARK:- Delete
    
    func showDeletePopUp(index: Int){
        
        UIApplication.topViewController?.alert(title: Messages.AlarmM.alarm, message: Messages.AlarmM.delete_alarm, defaultButton: "Yes", cancelButton: "No", completion: { (success) in
            
            if success{
                guard let objects = self.fetchedResultController.fetchedObjects else {return}
                objects[index].delete(context: self.managedContext)
            }
        })
    }
    
    //MARK:- fetch
    
    func fetchResults() {
        
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetch_request(sort: [NSSortDescriptor(key: "reminder_time", ascending: true)], predicate: NSPredicate(format: "reminder_time >= %@", Date().startOfDay as CVarArg))
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
