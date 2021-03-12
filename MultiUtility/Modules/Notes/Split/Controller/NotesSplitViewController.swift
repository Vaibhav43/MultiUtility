//
//  NotesSplitViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 11/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class NotesSplitViewController: UISplitViewController {

    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- instance
    
    class func instance(){
        let vc = NotesSplitViewController()
        AppDelegate.rootWindow?.rootViewController = vc
    }
    
    //MARK:- setup
    
    func setup(){
        preferredDisplayMode = .allVisible
        let notesVC = NotesListViewController.initFromNib
        let notesNavigation = UINavigationController(rootViewController: notesVC)
        let addNotesVC = AddNotesViewController.instance(notes: nil)
        let addnotesNavigation = UINavigationController(rootViewController: addNotesVC)
        self.viewControllers = [notesNavigation, addnotesNavigation]
    }
}
