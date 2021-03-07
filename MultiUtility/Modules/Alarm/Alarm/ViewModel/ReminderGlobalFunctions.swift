//
//  ReminderGlobalFunctions.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import CoreData

extension GlobalFunctions{
    
    struct Reminder {
        
//        static func updateReminders(completion: ((Bool)->())? = nil){
//            
//            let context = CoreData.shared.managedContext
//            
//            // Initialize Batch Update Request
//            let batchUpdateRequest = NSBatchUpdateRequest(entityName: "Reminder")
//            
//            // Configure Batch Update Request
//            batchUpdateRequest.resultType = .statusOnlyResultType
//            batchUpdateRequest.propertiesToUpdate = ["is_expired": NSNumber(value: true)]
//            batchUpdateRequest.predicate = NSPredicate(format: "reminder_time < %@", NSDate())
//            
//            do {
//                // Execute Batch Request
//                let batchUpdateResult = try context.execute(batchUpdateRequest) as! NSBatchUpdateResult
//                
//                // Perform Fetch
//                completion?(batchUpdateResult.result as? Bool ?? true)
//            }
//            catch {
//                let updateError = error as NSError
//                print("\(updateError), \(updateError.userInfo)")
//                completion?(false)
//            }
//        }
    }
}
