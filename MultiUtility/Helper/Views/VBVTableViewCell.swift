//
//  VBVTableViewCell.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 03/03/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension VBVTableViewCell{
    
    static var identifier: String{
        return self.debugDescription().components(separatedBy: ".")[1]
    }
    
    static var nib: UINib{
        return UINib(nibName: self.debugDescription(), bundle: nil)
    }
}
