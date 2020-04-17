//
//  AlarmListTableViewCell.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 17/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AlarmListTableViewCell: VBVTableViewCell {
    
    @IBOutlet weak var containerView: VBVView!{
        didSet{
            containerView.backgroundColor = UIColor.custom_separatorGrey
        }
    }
    @IBOutlet weak var timeLabel: VBVLabel!{
        didSet{
            timeLabel.textAlignment = .right
            timeLabel.textColor = UIColor.black
            timeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet weak var titleLabel: VBVLabel!{
        didSet{
            titleLabel.textAlignment = .left
            titleLabel.textColor = UIColor.custom_text
            titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        }
    }
    @IBOutlet weak var dateLabel: VBVLabel!{
        didSet{
            dateLabel.textAlignment = .right
            dateLabel.textColor = UIColor.black
            dateLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    
    var reminder = Reminder(){
        didSet{
            setData()
        }
    }
    
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
        containerView.cornerRadius = .light
    }

    //MARK:- Setup
    
    func setData(){
        
        self.titleLabel.text = reminder.title
        self.dateLabel.text = reminder.reminder_time?.toString(format: .dayDash)
        self.timeLabel.text = reminder.reminder_time?.toString(format: .time)
    }
}
