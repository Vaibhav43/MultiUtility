//
//  AddNotesViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation

class AddNotesViewModal{
    
    var managedContext = CoreData.shared.managedContext
    var reloadTable: (() -> ())?
    var notes: Notes?
}
