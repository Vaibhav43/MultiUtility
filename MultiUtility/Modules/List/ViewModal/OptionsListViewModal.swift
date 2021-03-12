//
//  OptionsListViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class OptionsListViewModal{
    
    enum Options: String, CaseIterable{
        
        case alarm = "Alarm"
        case notes = "Notes"
    }
    
    let optionsArray: [Options] = Options.allCases
    
    //MARK:- Other
    
    func navigate(indexPath: IndexPath){
        
        if UIDevice.current.isIPhone{
            self.iPhone_navigation(indexPath: indexPath)
        }
        else{
            self.ipad_navigation(indexPath: indexPath)
        }
    }
}
