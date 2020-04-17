//
//  VBVCollectionView.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 23/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVCollectionViewCell: UICollectionViewCell{
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class VBVCollectionView: UICollectionView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension VBVCollectionViewCell{
    
    static var identifier: String{
        return self.debugDescription().components(separatedBy: ".")[1]
    }
    
    static var nib: UINib{
        return UINib(nibName: self.debugDescription(), bundle: nil)
    }
}

extension VBVCollectionView{
    
    func register(types: [VBVCollectionViewCell.Type]){
        
        types.forEach { (cell) in
            
            let identifier = cell.identifier
            self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        }
    }
    
    func register(types: [CollectionCells]){
        types.forEach { (cell) in
            self.register(UINib(nibName: cell.rawValue, bundle: nil), forCellWithReuseIdentifier: cell.rawValue)
        }
    }
}
