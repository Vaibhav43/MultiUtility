//
//  OptionsListViewModal.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation

class OptionsListViewModal{
    
    enum Options: String, CaseIterable{
        
        case alarm = "Alarm"
        case notes = "Notes"
    }
    
    let optionsArray: [Options] = Options.allCases
}
