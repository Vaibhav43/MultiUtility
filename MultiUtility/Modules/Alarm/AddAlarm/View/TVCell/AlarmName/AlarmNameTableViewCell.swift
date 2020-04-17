//
//  AlarmNameTableViewCell.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 14/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AlarmNameTableViewCell: VBVTableViewCell {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: VBVTextfield!

    //MARK:- lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.borders(for: [.bottom], width: 1.0, color: UIColor.darkGray, rounded: false)
    }
    
    //MARK:- Setup
    
    func setData(heading: String?, placeHolder: String?){
        self.headingLabel.text = heading
        self.textField.placeholder = placeHolder
    }
}
