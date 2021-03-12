//
//  iPadOptionListViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 12/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

extension OptionsListViewModal{
    
    func ipad_navigation(indexPath: IndexPath){
        
        let data = optionsArray[indexPath.row]
        
        switch data {
        
        case .alarm:
            AlarmSplitViewController.instance()
            
        case .notes:
            NotesSplitViewController.instance()
        }
    }
}
