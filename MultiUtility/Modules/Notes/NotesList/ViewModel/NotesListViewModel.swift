//
//  NotesListViewModel.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 10/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import CoreData

class NotesListViewModel{
    
    var recordsFetched: (()->())?
    var managedContext = CoreData.shared.persistentContainer.newBackgroundContext()
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
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetch_request(sort: [NSSortDescriptor(key: "updated_time", ascending: true)], predicate: nil, groupBy: nil)
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
}
