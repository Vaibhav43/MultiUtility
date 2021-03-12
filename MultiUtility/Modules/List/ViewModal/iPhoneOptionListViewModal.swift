//
//  iPhoneOptionListViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 12/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

extension OptionsListViewModal{
    
    func iPhone_navigation(indexPath: IndexPath){
        
        guard let navigation = AppDelegate.navigation else {return}
        
        let data = optionsArray[indexPath.row]
        
        switch data {
        
        case .alarm:
            AlarmTabViewController.instance(navigation: navigation)
            
        case .notes:
            NotesTabViewController.instance(navigation: navigation)
        }
    }
}
