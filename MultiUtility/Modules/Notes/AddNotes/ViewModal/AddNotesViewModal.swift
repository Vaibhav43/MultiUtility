//
//  AddNotesViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class AddNotesViewModal{
    
    var managedContext = CoreData.shared.managedContext
    var reloadUI: (() -> ())?
    var notes: Notes?
    
    var selectedBackgroundColor = UIColor.Notes.Background.kCream{
        didSet{
            reloadUI?()
        }
    }
    lazy var colorArray = UIColor.Notes.Background.array
}
