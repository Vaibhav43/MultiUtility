//
//  AlarmTabViewController.swift
//  Alarm
//
//  Created by apple on 11/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AlarmTabViewController: UITabBarController {
    
    let array: [(name: String, image: String)] = [("Alarm", "clock"), ("List", "list_add")]
    
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

    //MARK:- Setup
    
    func setHeader(){
        self.navigationController?.navigationBar.tintColor = UIColor.Alarm.kappearance
    }
    
    func setup(){
        
        let homeVC = AlarmViewController.initFromNib
        let alarmVC = AlarmListViewController.initFromNib
        self.viewControllers = [homeVC, alarmVC]
        setItems()
    }
    
    func setItems(){
        
        UITabBar.appearance().tintColor = UIColor.Alarm.kappearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        self.tabBar.items?.enumerated().forEach({ (item) in
            let tuple = self.array[item.offset]
            item.element.title = tuple.name
            item.element.image = UIImage(named: tuple.image)
            item.element.selectedImage = UIImage(named: tuple.image)
        })
    }
}
