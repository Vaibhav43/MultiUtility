//
//  Extensions.swift
//  VBVFramework
//
//  Created by Evolko iOS on 1/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate{
    
    static var instance: AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static var navigation: UINavigationController?{
        return instance.window?.rootViewController as? UINavigationController
    }
}


extension Data{
    
    var toBytes: [UInt8]{
        return [UInt8] (self)
    }
    
    var toString: String?{
        return self.base64EncodedString(options: .lineLength64Characters)
    }
}

extension CALayer {
    
    func addDashedLineBorder(color: UIColor, edge: UIRectEdge, thickness: CGFloat = 4.0) {
        removeBorder(edge: edge)
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "border\(edge.rawValue)"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = thickness
        shapeLayer.lineDashPattern = [6, 2]
        
        let path = CGMutablePath()
        
        if edge == .top{
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: frame.width, y: 0))
        }
        else if edge == .bottom{
            path.move(to: CGPoint(x: 0, y: frame.height))
            path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        }
        
        shapeLayer.path = path
        self.addSublayer(shapeLayer)
    }
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        removeBorder(edge: edge)
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.name = "border\(edge.rawValue)"
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
    
    func removeBorder(edge: UIRectEdge){
        
        self.sublayers?.removeAll(where: { (layer) -> Bool in
            return layer.name == "border\(edge.rawValue)"
        })
    }
}

extension IndexPath{
    
    func increase(by row: Int, section: Int = 0) -> IndexPath{
        return IndexPath(row: self.row+row, section: self.section+section)
    }
    
    static func of(_ sender: AnyObject, objectView: AnyObject) -> IndexPath? {
        
        if let object = objectView as? UITableView{
            let hitpoint = sender.convert(CGPoint.zero, to: object)
            return object.indexPathForRow(at: hitpoint)
        }
        else if let object = objectView as? UICollectionView{
            let hitpoint = sender.convert(CGPoint.zero, to: object)
            return object.indexPathForItem(at: hitpoint)
        }
        
        return nil
    }
}

extension Array where Element == UInt8 {
    
    var data : Data{
        return Data(self)
    }
    
    var toImage: UIImage?{
        
        let datos: Data = Data(bytes: self, count: self.count)
        return UIImage(data: datos)
    }
}


extension Array where Element == Int64 {
    
    var toData: Data{
        return self.toInt8.data
    }
    
    var toInt8: [UInt8]{
        
        var bytes = [UInt8]()
        for i in 0..<self.count {
            bytes.append(UInt8(bitPattern: Int8(self[i])))
        }
        
        return bytes
    }
    
    var toImage: UIImage?{
        
        let bytes = self.toInt8
        let datos: Data = Data(bytes: bytes, count: bytes.count)
        return UIImage(data: datos)
    }
}

extension Array where Element: NSAttributedString {
    
    func joined(separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }
    
    func joined(separator: String) -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

extension Array where Element == Dictionary<String, Any>{
    
    var toString: String?{
        
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)
        return decoded
    }
}
