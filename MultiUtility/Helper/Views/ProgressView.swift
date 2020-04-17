//
//  ProgressView.swift
//  VBVFramework
//
//  Created by Vaibhav Agarwal on 29/11/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVProgressView: UIView {
    
    var emptyColor: UIColor = .clear
    var filledColor: UIColor = .green
    
    var progress: CGFloat = 0.0{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setProgress()
    }
    
    func setProgress() {
        
        var progress = self.progress
        progress = progress > 1.0 ? progress / 100 : progress
        
        let width = (self.frame.width)  * progress
        let height = self.frame.height
        
        self.layer.cornerRadius = height*0.4
        self.layer.borderColor = UIColor.clear.cgColor
        
        
        let pathRef = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: height * 0.4)
        
        filledColor.setFill()
        pathRef.fill()
        
        emptyColor.setStroke()
        pathRef.stroke()
        pathRef.close()
        
        self.setNeedsDisplay()
    }
}
