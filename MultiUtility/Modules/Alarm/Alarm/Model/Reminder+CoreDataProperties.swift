//
//  Reminder+CoreDataProperties.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 17/04/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var title: String?
    @NSManaged public var message: String?
    @NSManaged public var task: String?
    @NSManaged public var created_time: Date?
    @NSManaged public var reminder_time: Date?

}
