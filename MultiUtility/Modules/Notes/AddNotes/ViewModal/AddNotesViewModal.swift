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
    
    var reloadUI: (() -> ())?
    var managedContext = CoreData.shared.managedContext
    var notes: Notes?{
        didSet{
            setNotes()
        }
    }
    
    var selectedBackgroundColor = UIColor.Notes.Background.kCream{
        didSet{
            setColor()
        }
    }
    lazy var colorArray = [(UIColor, Bool)]()
    
    //MARK:- Setup
    
    func setColor(){
        
        colorArray.removeAll()
        
        for color in UIColor.Notes.Background.array{
            colorArray.append((color, color == selectedBackgroundColor))
        }
        
        reloadUI?()
    }
    
    func setNotes(){
        
        if let notes = notes{
            selectedBackgroundColor = UIColor.init(hex: notes.color ?? "ffffff")
            setColor()
        }
        else{
            notes = Notes(context: managedContext)
        }
    }
    
    //MARK:- Save
    
    func saveNotes(){
        
        notes?.color = selectedBackgroundColor.hexString
        notes?.is_favorite = notes?.is_favorite ?? false
        notes?.created_time = notes?.created_time ?? Date()
        notes?.updated_time = notes?.updated_time ?? Date()
        notes?.managedObjectContext?.saveContext()
    }
}
