//
//  Constants.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 13/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import CoreLocation


func print<T: Any>(value: T){
    debugPrint(value)
}

//let menuItem1: UIMenuItem = UIMenuItem(title: "Menu 1", action: #selector(onMenu1(sender:)))
//let menuItem2: UIMenuItem = UIMenuItem(title: "Menu 2", action: #selector(onMenu2(sender:)))
//let menuItem3: UIMenuItem = UIMenuItem(title: "Menu 3", action: #selector(onMenu3(sender:)))
//
//// Store MenuItem in array.
//let myMenuItems: [UIMenuItem] = [menuItem1, menuItem2, menuItem3]
//
//// Added MenuItem to MenuController.
//menuController.menuItems = myMenuItems

class AsyncOperation {
    
    typealias NumberOfPendingActions = Int
    typealias DispatchQueueOfReturningValue = DispatchQueue
    typealias CompleteClosure = ()->()
    
    private let dispatchQueue: DispatchQueue
    private var semaphore: DispatchSemaphore
    
    private var numberOfPendingActionsQueue: DispatchQueue
    public private(set) var numberOfPendingActions = 0
    
    var whenCompleteAll: (()->())?
    
    init(numberOfSimultaneousActions: Int, dispatchQueueLabel: String) {
        dispatchQueue = DispatchQueue(label: dispatchQueueLabel)
        semaphore = DispatchSemaphore(value: numberOfSimultaneousActions)
        numberOfPendingActionsQueue = DispatchQueue(label: dispatchQueueLabel + "_numberOfPendingActionsQueue")
    }
    
    func run(closure: @escaping (@escaping CompleteClosure)->()) {
        
        self.numberOfPendingActionsQueue.sync {
            self.numberOfPendingActions += 1
        }
        
        dispatchQueue.async {
            self.semaphore.wait()
            closure {
                self.numberOfPendingActionsQueue.sync {
                    self.numberOfPendingActions -= 1
                    if self.numberOfPendingActions == 0 {
                        self.whenCompleteAll?()
                    }
                }
                self.semaphore.signal()
            }
        }
    }
}

func executeInBackground(background: (() -> Void)? = nil, completion: (() -> Void)? = nil){
    
    DispatchQueue.global(qos: .background).async {
        background?()
        
        if let completion = completion{
            
            DispatchQueue.main.async(execute: {
                completion()
            })
        }
    }
}

