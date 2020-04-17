//
//  VBVTableView.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 23/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVTableView: UITableView{
    
    var separatorLineColor = UIColor.clear{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    /// hide the separators that cell doesnt have
    var hideSeparateLines: Bool = false{
        didSet{
            self.tableFooterView = hideSeparateLines ? UIView() : nil
        }
    }
    
    //MARK:- lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.separatorColor = separatorLineColor
    }
    
    //MARK:- setup
}

extension VBVTableView{
    
    var contentsize: CGFloat{
        
        let screenSize = UIScreen.main.bounds.height
        let height = self.contentSize.height + self.frame.origin.y
        
        if abs(screenSize-height) > 150 {
            return abs(screenSize-height)+20
        }
        
        return 150
    }
    
    func mainReload(){
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func register(types: [VBVTableViewCell.Type]){
        
        types.forEach { (cell) in
            
            let identifier = cell.identifier
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    
    func register(types: [TableCells]){
        types.forEach { (cell) in
            self.register(UINib(nibName: cell.rawValue, bundle: nil), forCellReuseIdentifier: cell.rawValue)
        }
    }
    
    func alignCellInMiddle(){
        let tableViewHeight = self.frame.height
        let contentHeight = self.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        
        self.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func setup(){
        
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.rowHeight = UITableView.automaticDimension
    }
    
    //MARK:- PDF
    
    // Export pdf from UITableView and save pdf in drectory and return pdf file path
    var createPdf: String {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentSize.height)
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        self.bounds = originalBounds
        
        // Save pdf data
        return self.savePdf(data: pdfData)
    }
    
    // Save pdf file in document directory
    func savePdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("tablePdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
