
//
//  CustomBarChartCell.swift
//  VBVFramework
//
//  Created by apple on 29/01/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit


class BarCVCell: UICollectionViewCell{
    
    let barLabel: VBVLabel = {
        let label = VBVLabel()
        label.contentMode = .top
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var heightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        contentView.addSubview(barLabel)
        barLabel.backgroundColor = .green
        barLabel.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -5).isActive = true
        barLabel.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor, constant: 5).isActive = true
        barLabel.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -1).isActive = true
        heightConstraint = barLabel.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
    }
}

class BPBarCVCell: UICollectionViewCell{
    
    let systolicLabel: VBVLabel = {
        let label = VBVLabel()
        label.contentMode = .top
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let diastolicLabel: VBVLabel = {
        let label = VBVLabel()
        label.contentMode = .top
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var systolicHeight = NSLayoutConstraint()
    var diastolicHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        contentView.addSubview(systolicLabel)
        contentView.addSubview(diastolicLabel)
        systolicLabel.backgroundColor = .green
        diastolicLabel.backgroundColor = .blue
        
        systolicLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2).isActive = true
        systolicLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1).isActive = true
        systolicLabel.trailingAnchor.constraint(equalTo: diastolicLabel.leadingAnchor, constant: -1).isActive = true
        systolicLabel.widthAnchor.constraint(equalTo: diastolicLabel.widthAnchor, constant: 0).isActive = true
        systolicHeight = systolicLabel.heightAnchor.constraint(equalToConstant: 50)
        systolicHeight.isActive = true
        
        diastolicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2).isActive = true
        diastolicLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1).isActive = true
        diastolicHeight = diastolicLabel.heightAnchor.constraint(equalToConstant: 50)
        diastolicHeight.isActive = true
    }
}

