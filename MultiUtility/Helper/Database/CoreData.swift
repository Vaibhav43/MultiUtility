//
//  CoreData.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 12/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import CoreData

class CoreData{
    
    static let shared = CoreData()
    var managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    //MARK:- initiate
    
    func createNewContext(mergeWithParent: Bool) -> NSManagedObjectContext{
        
        let managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = CoreData.shared.persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = mergeWithParent
        return managedContext
    }
    
    func initiaze(){
        managedContext = persistentContainer.viewContext
    }
    
    //MARK:- Persistent
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MultiUtility")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        if managedContext.hasChanges {
            do {
                
                try managedContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension NSManagedObject{
    
    class func create<T: NSManagedObject>(context: NSManagedObjectContext? = nil) -> T {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: T.entityName, in: context ?? CoreData.shared.managedContext) else { fatalError("Unable to create \(T.entityName) NSEntityDescription") }
        
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context ?? CoreData.shared.managedContext) as? T else { fatalError("Unable to create \(T.entityName) NSManagedObject")}
        
        return object
    }
    
    class var entityName: String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last!
        return name
    }
    
    func delete(context: NSManagedObjectContext? = nil){
        
        if context != nil{
            context?.delete(self)
            context?.saveContext()
        }
        else{
            CoreData.shared.managedContext.delete(self)
            CoreData.shared.managedContext.saveContext()
            
        }
    }
    
    class func fetch<T: NSManagedObject>(sort: [NSSortDescriptor]? = nil, predicate: NSPredicate?) -> [T]? {
        
        let request: NSFetchRequest<T> = fetch_request(sort: sort, predicate: predicate)
        
        do {
            let result = try CoreData.shared.managedContext.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func fetch_request<T: NSManagedObject>(sort: [NSSortDescriptor]? = nil, predicate: NSPredicate?) -> NSFetchRequest<T> {
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sort
        request.predicate = predicate
        return request
    }
}

// MARK: - Core Data Saving support
extension NSManagedObjectContext{
    
    func saveContext () {
        guard self.hasChanges else { return }
        do {
            try self.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension Array{
    
    func common<T:Hashable>(second: T, map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        let set2 = Set<T>(arrayLiteral: second)
        
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        
        for value in self {
            
            if !set2.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
    
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
    
    //    func reset<T:Hashable>(variable: ((Element) -> (T)), value: T) -> [Element]{
    //
    //        var newArray = self
    //
    //        for (index, element) in self.enumerated(){
    //            variable(newArray[index])
    //            newArray[index](variable) = value
    //        }
    //
    //        return newArray
    //    }
}
