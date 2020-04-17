//
//  CustomBarChartView.swift
//  BarChartLiveStream
//
//  Created by Evolko iOS on 1/7/19.
//  Copyright © 2019 Lets Build That App. All rights reserved.
//

import UIKit

struct BarChart {
    
    var chartMaxValue: CGFloat = 5
    var chartMinValue: CGFloat = 0
    
    /// for the range of bar shown below the chart to depict the normal range
    lazy var barRange = [CustomBarChartView.BarRange]()
    
    /// x axis values
    lazy var xValues = [[String]]()
    lazy var titles = [String]()
    
    var xAxis = Axis()
    
    var yAxis = Axis()
    
    var xLabelAlignment = NSTextAlignment.center
    
    mutating func setAxis(){
        
        let color = UIColor.lightGray
        let font = UIFont.systemFont(ofSize: 14)
        xAxis = Axis(lineColor: color, textColor: color, font: font, numberOfLabels: titles.count)
        yAxis = Axis(lineColor: color, textColor: color, font: font, numberOfLabels: 5)
    }
}

struct Axis{
    
    var lineColor: UIColor = .black
    var textColor: UIColor = .black
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var numberOfLabels = 5
}

class CustomBarChartView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var xAxisviewHeight: NSLayoutConstraint!
    @IBOutlet weak var xAxisView: UIView!
    @IBOutlet weak var xAxisStackView: UIStackView!
    @IBOutlet weak var yAxisStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var gridView: CustomGridView!
    @IBOutlet weak var dateWidth: NSLayoutConstraint!
    @IBOutlet weak var gridContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            
            collectionView.register(BPBarCVCell.self, forCellWithReuseIdentifier: "BPBarCVCell")
            collectionView.register(BarCVCell.self, forCellWithReuseIdentifier: "BarCVCell")
            (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
            collectionView.backgroundColor = UIColor.clear
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    /// alias range of bar shown below the chart to depict the normal range
    typealias BarRange = (start: CGFloat, end: CGFloat, color: UIColor, maximum: CGFloat)
    
    var barChartValues = BarChart()
    
    var barClicked: (()->())?
    var barWidth: CGFloat = 0
    
    
    //MARK:- lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.layer.cornerRadius = 8
        if barWidth == 0{
            self.setProperties()
        }
    }
    
    //MARK:- instance
    
    class func instance(barchart: BarChart) -> CustomBarChartView {
        
        let instance = Bundle.main.loadNibNamed("CustomBarChartView", owner: self, options: nil)?[0] as! CustomBarChartView
        instance.barChartValues = barchart
        return instance
    }
    
    //MARK:- setup
    
    func setProperties(){
        
        setGridView()
        
        addYLabel()
        addXLabel()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.03) {
            self.barWidth = max(self.gridView.frame.width/CGFloat(self.barChartValues.xValues.count), 10)
            self.collectionView.reloadData()
        }
    }
    
    func setGridView(){
        
        gridView.numberOfRows = 0
        gridView.numberOfColumns = barChartValues.titles.count
        gridView.axisColor = barChartValues.xAxis.lineColor
        gridView.barRange = barChartValues.barRange
    }
    
    //MARK:- Axis Labels
    
    func addXLabel(){
        
        guard xAxisStackView.arrangedSubviews.isEmpty else{
            xAxisviewHeight.constant = 0
            return
        }
        
        xAxisviewHeight.constant = 30
        let xAxis = barChartValues.xAxis
        let alignment: NSTextAlignment = barChartValues.xLabelAlignment//(barChartValues.titles.count <= 5) ? .right : .center
        
        for title in barChartValues.titles{
            
            let label = VBVLabel()
            label.contentMode = .left
            label.textColor = xAxis.textColor
            label.font = xAxis.font
            label.text = title
            label.textAlignment = alignment
            label.adjustsFontSizeToFitWidth = true
            xAxisStackView.addArrangedSubview(label)
        }
    }
    
    func addYLabel(){
        
        guard yAxisStackView.arrangedSubviews.isEmpty && (barChartValues.chartMinValue != 0 || barChartValues.chartMaxValue != 0) else {
            dateWidth.constant = 0
            return
        }
        
        let division = Int(ceil((barChartValues.chartMaxValue - barChartValues.chartMinValue)/CGFloat(barChartValues.yAxis.numberOfLabels)))
        
        dateWidth.constant = 30
        let yAxis = barChartValues.yAxis
        
        for index in (0...yAxis.numberOfLabels).reversed(){
            
            let value = CGFloat(division*index)+barChartValues.chartMinValue
            
            ///for option values some options has only 4 records so we cannot make 5 labels for it
            if value > barChartValues.chartMaxValue{
                continue
            }
            
            let label = VBVLabel()
            label.contentMode = .top
            label.textColor = yAxis.textColor
            label.font = yAxis.font
            label.text = "\(Int(value))"
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            yAxisStackView.addArrangedSubview(label)
        }
    }
    
    func removeYLabels(){
        
        yAxisStackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}

extension CustomBarChartView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var maxHeight: CGFloat {
        return collectionView.bounds.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barChartValues.xValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let xValue = barChartValues.xValues[indexPath.row]
        
        if xValue.count == 2{
            return bpCell(values: xValue, indexPath: indexPath)
        }
        
        return barcell(values: xValue, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        barClicked?()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: barWidth, height: collectionView.bounds.height)
    }
    
    //MARK:- cells
    
    func bpCell(values: [String], indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BPBarCVCell", for: indexPath) as! BPBarCVCell
        cell.systolicHeight.constant = 0
        cell.diastolicHeight.constant = 0
        
        if let sys = values.first{
            
            let ratio = (CGFloat(Double(sys) ?? 0.0)) / barChartValues.chartMaxValue
            cell.systolicHeight.constant = (maxHeight * ratio).finiteValue
            cell.systolicLabel.text = nil
        }
        
        if let dias = values.last{
            
            let ratio = (CGFloat(Double(dias) ?? 0.0)) / barChartValues.chartMaxValue
            cell.diastolicHeight.constant = (maxHeight * ratio).finiteValue
            cell.diastolicLabel.text = nil
        }
        
        cell.systolicLabel.adjustsFontSizeToFitWidth = true
        cell.diastolicLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func barcell(values: [String], indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarCVCell", for: indexPath) as! BarCVCell
        cell.heightConstraint.constant = 0
        cell.barLabel.text = nil
        
        if let response = values.first{
            let value = Double(response) ?? 0.0
            let ratio = (CGFloat(value)) / (barChartValues.chartMaxValue)
            let constant = (maxHeight * CGFloat(ratio))
            cell.heightConstraint.constant = constant.finiteValue
            cell.barLabel.text = nil
        }
        
        cell.barLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
}
