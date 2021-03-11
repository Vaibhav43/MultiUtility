//
//  NotesSplitViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 11/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class NotesSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    class func instance(){
        
        let vc = NotesSplitViewController()
        AppDelegate.rootWindow?.rootViewController = vc
    }
    
    func setup(){
        preferredDisplayMode = .allVisible
        let notesVC = NotesListViewController.initFromNib
        let notesNavigation = UINavigationController(rootViewController: notesVC)
        let addNotesVC = AddNotesViewController.instance(notes: nil)
        let addnotesNavigation = UINavigationController(rootViewController: addNotesVC)
        self.viewControllers = [notesNavigation, addnotesNavigation]
    }
}
