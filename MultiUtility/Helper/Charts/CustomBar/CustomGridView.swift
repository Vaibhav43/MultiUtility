//
//  CustomGridView.swift
//  BarChartLiveStream
//
//  Created by Evolko iOS on 1/4/19.
//  Copyright © 2019 Lets Build That App. All rights reserved.
//

import UIKit

class CustomGridView: UIView {
    
    var axisColor = UIColor.black
    
    /// number of column leaving the y-axis ones
    var numberOfColumns: Int = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    /// number of rows leaving the x-axis ones
    var numberOfRows: Int = 0
    
    /// for the range of bar shown below the chart to depict the normal range
    lazy var barRange = [CustomBarChartView.BarRange]()
    
    var lineWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.borderColor = axisColor.cgColor
        self.layer.borderWidth = lineWidth
        drawRow(rect)
        drawColumn(rect)
        drawBarRange(rect)
    }
    
    func drawRow(_ rect: CGRect){
        
        if numberOfRows > 0, let context = UIGraphicsGetCurrentContext() {
            context.clear(rect)
            context.setLineWidth(lineWidth)
            context.setStrokeColor(axisColor.cgColor)
            
            let rowHeight: CGFloat = (rect.height / CGFloat(numberOfRows+1))
            
            for j in 1...numberOfRows {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = 0.0
                startPoint.y = (rowHeight * CGFloat(j))
                endPoint.x = frame.size.width
                endPoint.y = startPoint.y
                
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
        }
    }
    
    func drawColumn(_ rect: CGRect){
        
        if numberOfColumns > 0, let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(lineWidth)
            context.setStrokeColor(axisColor.cgColor)
            
            let columnWidth: CGFloat = (rect.width / CGFloat(numberOfColumns))
            
            for i in 1...numberOfColumns{
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = columnWidth*(CGFloat(i))
                startPoint.y = 0.0
                endPoint.x = startPoint.x
                endPoint.y = frame.size.height
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
        }
    }
    
    func drawBarRange(_ rect: CGRect){
        
        if !barRange.isEmpty, let context = UIGraphicsGetCurrentContext(){
            
            for range in barRange{
                
                context.setLineWidth(1)
                context.setStrokeColor(UIColor.clear.cgColor)
                context.setFillColor(range.color.withAlphaComponent(0.5).cgColor)
                
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                
                ///single straight line
                let startHeight = (range.start/range.maximum)*rect.height
                startPoint.x = 0
                startPoint.y = rect.height - startHeight
                endPoint.x = rect.width
                endPoint.y = rect.height - startHeight
                
                context.move(to: startPoint)
                context.addLine(to: endPoint)
                
                /// the ratio of the start and end date in respect to maximum value
                let ratio = (range.end - range.start)/range.maximum
                
                /// the height of the range abr
                let height = rect.height*ratio
                startPoint.y -= height
                endPoint.y -= height
                
                ///top to bottom from the line
                context.addLine(to: endPoint)
                
                ///second straight line
                context.addLine(to: CGPoint(x: 0, y: endPoint.y))
                
                context.fillPath()
                context.strokePath()
                
                ///to remove all the context just use this
//                context.clear(rect)
            }
        }
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
}

