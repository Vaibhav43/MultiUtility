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
    
    var reloadTable: (() -> ())?
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<Reminder>()
    var alarmList = GenericObserverDataSource<Reminder>()
    
    func showDeletePopUp(index: Int){
        
        UIApplication.topViewController?.alert(title: Messages.AlarmM.alarm, message: Messages.AlarmM.delete_alarm, defaultButton: "Yes", cancelButton: "No", completion: { (success) in
            
        })
    }
    
    func fetchData(){
        let predicate = NSPredicate(format: "reminder_time >= %@ AND reminder_time <= %@", Date().startOfDay as CVarArg, Date().endOfDay as CVarArg)
        
        if let array: [Reminder] = Reminder.fetch(sort: [NSSortDescriptor(key: #keyPath(Reminder.reminder_time), ascending: true)], predicate: predicate){
            alarmList.data.value = array
        }
    }
    
    func fetchResults() {
        let fetchRequest = NSFetchRequest<Reminder>(entityName: Reminder.entityName)
        let sortDescriptor = NSSortDescriptor(key: "reminder_time", ascending: true)
        
        //AND reminderTime <= %@    , Date().endOfDay as CVarArg
        let predicate = NSPredicate(format: "reminder_time >= %@", Date().startOfDay as CVarArg)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreData.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

extension AlarmListViewModel: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("change happends")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at     indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            if let index = newIndexPath{
                self.reloadTable?()
            }
            
        default:
            break
        }
    }
}

