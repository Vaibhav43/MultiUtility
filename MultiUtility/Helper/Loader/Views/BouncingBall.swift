//
//  BouncingBall.swift
//  Demo
//
//  Created by Vaibhav Agarwal on 10/03/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class BouncingBall{
    
    static let shared = BouncingBall()
    
    //MARK:- functions
    
    func configure(in layer: CALayer, size: CGSize, color: UIColor){
        setUpAnimation(in: layer, size: size, color: color)
    }
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        for index in (0...1) {
            bouncingBall(in: layer, size: size, color: color, startingAt: CACurrentMediaTime() + Double(index))
        }
    }
    
    fileprivate func bouncingBall(in layer: CALayer, size: CGSize, color: UIColor, startingAt: CFTimeInterval) {
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [-1, 0, -1]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.isRemovedOnCompletion = false
        
        let circle = setSize(size: size, color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                           y: (layer.bounds.size.height - size.height) / 2,
                           width: size.width,
                           height: size.height)
        
        scaleAnimation.beginTime = startingAt
        circle.frame = frame
        circle.opacity = 0.6
        circle.add(scaleAnimation, forKey: "animation")
        circle.name = "circle"
        layer.addSublayer(circle)
    }
    
    func setSize(size: CGSize, color: UIColor) -> CAShapeLayer{
        
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }
}
