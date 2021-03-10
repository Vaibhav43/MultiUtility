//
//  NotesTabViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 10/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class NotesTabViewController: UITabBarController {
    
    let array: [(name: String, image: String)] = [("List", "notes_list"), ("Add", "addnotes")]
    
    //MARK:- lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeader()
    }
    
    //MARK:- Instance
    
    class func instance(navigation: UINavigationController){
        
        let vc = NotesTabViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    //MARK:- Setup

    func setHeader(){
        self.navigationController?.navigationBar.tintColor = UIColor.Notes.ktheme
    }
    
    func setup(){
        
        let homeVC = NotesListViewController.initFromNib
        let alarmVC = AddNotesViewController.initFromNib
        self.viewControllers = [homeVC, alarmVC]
        setItems()
    }
    
    func setItems(){
        
        UITabBar.appearance().tintColor = UIColor.Notes.ktheme
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        self.tabBar.items?.enumerated().forEach({ (item) in
            let tuple = self.array[item.offset]
            item.element.title = tuple.name
            item.element.image = UIImage(named: tuple.image)
            item.element.selectedImage = UIImage(named: tuple.image)
        })
    }
}
