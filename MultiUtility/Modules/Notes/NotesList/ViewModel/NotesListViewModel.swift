//
//  NotesListViewModel.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 10/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotesListViewModel{
    
    var recordsFetched: (()->())?
    var managedContext = CoreData.shared.managedContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<Notes>()
    
    //MARK:- Tableview
    
    var numberOfSections: Int{
        return fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfRows(section: Int) -> Int{
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    //MARK:- fetch
    
    func fetchResults() {
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetch_request(sort: [NSSortDescriptor(key: "is_favorite", ascending: false), NSSortDescriptor(key: "updated_time", ascending: false)], predicate: nil, groupBy: nil)
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
            recordsFetched?()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            recordsFetched?()
        }
    }
    
    func showDeletePopUp(index: Int){
        
        UIApplication.topViewController?.alert(title: Messages.Notes.title, message: Messages.Notes.delete, defaultButton: "Yes", cancelButton: "No", completion: { (success) in
            
            if success{
                guard let objects = self.fetchedResultController.fetchedObjects else {return}
                objects[index].delete(context: self.managedContext)
            }
        })
    }
}
