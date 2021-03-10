//
//  ColorCollectionViewCell.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 10/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: VBVCollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.cornerRadius = .light
        }
    }
    
    //MARK:- lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        // Initialization code
    }
}
