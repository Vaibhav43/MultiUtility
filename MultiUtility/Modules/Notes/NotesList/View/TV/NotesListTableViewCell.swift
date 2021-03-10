//
//  NotesListTableViewCell.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 10/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class NotesListTableViewCell: VBVTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!{
        didSet{
            favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .selected)
            favoriteButton.tintColor = UIColor.Notes.ktheme
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.textColor = .lightGray
            descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            descriptionLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var updatedTimeLabel: UILabel!{
        didSet{
            descriptionLabel.textColor = .darkGray
            descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            descriptionLabel.numberOfLines = 1
        }
    }
    
    var notes: Notes?{
        didSet{
            setData()
        }
    }
    
    //MARK:- lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- Setup
    
    func setData(){
        
        guard let notes = notes else {return}
        let color = UIColor.init(hex: notes.color ?? "ffffff")
        containerView.set(cornerRadius: .light, borderWidth: 1, borderColor: color, backgroundColor: color.withAlphaComponent(0.6))
        titleLabel.text = notes.title
        descriptionLabel.text = notes.notes
        favoriteButton.isSelected = notes.is_favorite
        updatedTimeLabel.text = notes.updated_time?.processDate
    }
    
    //MARK:- Action
    
    @IBAction func favoriteClicked(_ sender: UIButton){
        sender.isSelected.toggle()
        notes?.is_favorite.toggle()
        notes?.managedObjectContext?.saveContext()
    }
}
