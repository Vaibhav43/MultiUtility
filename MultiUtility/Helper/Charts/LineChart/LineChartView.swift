//
//  LineChartView.swift
//  LineChart
//
//  Created by Evolko iOS on 1/8/19.
//  Copyright © 2019 Evolko iOS. All rights reserved.
//

import UIKit

class LineChartView: UIView, LineChartDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var lineChartWidth: NSLayoutConstraint!
  
    
    var lineChartWidthValue:CGFloat = 0
    
    var minimumValue: CGFloat = 0
    var maximumValue: CGFloat = 0
    
    // simple arrays
    var data = [CGFloat]()
    
    // simple line with custom x axis labels
    var xLabels = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instance() -> LineChartView{
        
        let chart = Bundle.main.loadNibNamed("LineChartView", owner: nil, options: [:])?[0] as! LineChartView
        return chart
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupChart(yValues: [CGFloat], xValues: [String], min: CGFloat, max: CGFloat){
        
        self.data = yValues
        self.xLabels = xValues
        self.minimumValue = min
        self.maximumValue = max
        
        if data.count == 1,  let first = data.first{
            minimumValue = first-(first*0.2)
            maximumValue = first+(first*0.2)
            self.data.insert(minimumValue, at: 0)
            self.xLabels.insert("", at: 0)
            lineChart.drawLine = false
            lineChart.x.grid.count = 3
            lineChart.y.grid.count = 3
        }
        else{
            lineChart.x.grid.count = CGFloat(data.count)
            lineChart.y.grid.count = CGFloat(data.count)
        }
        
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.minValue = (minimumValue != 0) ? minimumValue : nil
        lineChart.maxValue = (maximumValue != 0) ? maximumValue : nil
        lineChart.lineWidth = 1
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        
        
        lineChart.x.labels.visible = true
        lineChart.addLine(data)
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        
        lineChartWidthValue *= CGFloat(data.count)
        
        if lineChartWidthValue < self.bounds.width{
            lineChartWidthValue = (self.bounds.width-20)
        }
        
        lineChartWidth.constant = lineChartWidthValue
    }
    
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]){
        
    }
}
