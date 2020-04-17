//
//  DateCVCell.swift
//  CalendarDemo
//
//  Created by Vaibhav Agarwal on 29/11/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class DateCVCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var pointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        dateSelected(selected: false)
        dateFilled(filled: false)
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        bgView.layer.cornerRadius = bgView.frame.height/2
        pointLabel.layer.cornerRadius = pointLabel.frame.height/2
    }
    
    func dateSelected(selected: Bool){
        
        bgView.isHidden = !selected
        dateLabel.textColor = (selected) ? .white : .black
    }
    
    func dateFilled(filled: Bool){
        pointLabel.isHidden = !filled
    }
}
