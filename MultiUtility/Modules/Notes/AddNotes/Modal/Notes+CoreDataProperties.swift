//
//  Notes+CoreDataProperties.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var title: String?
    @NSManaged public var created_time: Date?
    @NSManaged public var updated_time: Date?
    @NSManaged public var notes: String?
    @NSManaged public var color: String?
    @NSManaged public var is_favorite: Bool

}
