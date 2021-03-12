//
//  AlarmSplitViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 12/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class AlarmSplitViewController: UISplitViewController {
    
    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- instance
    
    class func instance(){
        let vc = AlarmSplitViewController()
        AppDelegate.rootWindow?.rootViewController = vc
    }
    
    //MARK:- setup
    
    func setup(){
        preferredDisplayMode = .allVisible
        let alarmVC = AlarmViewController.initFromNib
        let alarmNavigation = UINavigationController(rootViewController: alarmVC)
        let listVC = AlarmListViewController.initFromNib
        let listNavigation = UINavigationController(rootViewController: listVC)
        self.viewControllers = [alarmNavigation, listNavigation]
    }
}
