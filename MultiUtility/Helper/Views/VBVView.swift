//
//  VBVView.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 09/03/20.
//  Copyright © 2020 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class VBVView: UIView {
    
    struct Pulsating {
        
        var fillColor = UIColor.white
        var animateTo: Double = 0
        var animateFrom: Double = 0
        var animateDuration: Double = 0
        let name = "pulsatingLayer"
    }
    
    var pulsatingLayer = CAShapeLayer()
    var pulsating: Pulsating?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    //MARK:- lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if pulsatingLayer.path == nil && (pulsating?.animateTo ?? 0) != 0{
            setPulsating()
        }
        else if pulsating == nil{
            removePulsating()
        }
    }
    
    //MARK:- Pulsating
    
    func setPulsating(){
        
        let path = UIBezierPath(arcCenter: .zero, radius: self.frame.height*0.5, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        pulsatingLayer.path = path.cgPath
        pulsatingLayer.fillColor = pulsating?.fillColor.withAlphaComponent(0.3).cgColor
        pulsatingLayer.lineCap = .round
        pulsatingLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        pulsatingLayer.name = pulsating?.name
        animate()
        self.layer.addSublayer(pulsatingLayer)
        self.clipsToBounds = false
    }
    
    func animate(){
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = pulsating?.animateTo
        animation.fromValue = pulsating?.animateFrom
        animation.duration = pulsating?.animateDuration ?? 1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: pulsating?.name)
    }
    
    func removePulsating(){
        
        pulsatingLayer.removeFromSuperlayer()
        pulsatingLayer.removeAllAnimations()
        pulsatingLayer = CAShapeLayer()
    }
}

extension VBVView{
    
    // MARK:- PDF
    
    // Export pdf from Save pdf in drectory and return pdf file path
    var createPDF: String {
        
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
    
    // MARK:- Shimmering
    
    func startShimmeringEffect() {
        
        let light = UIColor.white.cgColor
        let alpha = UIColor(red: 206/255, green: 10/255, blue: 10/255, alpha: 0.7).cgColor
        
        
        let gradient: CAGradientLayer = {
            
            let grd = CAGradientLayer()
            grd.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
            grd.colors = [light, alpha, light]
            grd.startPoint = CGPoint(x: 0.0, y: 0.5)
            grd.endPoint = CGPoint(x: 1.0,y: 0.525)
            grd.locations = [0.35, 0.50, 0.65]
            return grd
        }()
        
        
        let animation: CABasicAnimation = {
            
            let anim = CABasicAnimation(keyPath: "locations")
            anim.fromValue = [0.0, 0.1, 0.2]
            anim.toValue = [0.8, 0.9,1.0]
            anim.duration = 1.5
            anim.repeatCount = HUGE
            return anim
        }()
        
        
        self.layer.mask = gradient
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmeringEffect() {
        self.layer.mask = nil
    }
}
