//
//  UIImageView.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 23/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class VBVImageView: UIImageView{
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    private var imageEndPoint: String?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = UIColor.darkGray
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        layoutActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func layoutActivityIndicator() {
        activityIndicatorView.removeFromSuperview()
        
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func loadImage(from endPoint: String, placeHolder: UIImage?) {
        
        self.imageEndPoint = endPoint
        
        if let imageFromCache = VBVImageView.imageCache.object(forKey: endPoint as AnyObject) as? UIImage {
            setImage(imageFromCache)
            return
        }
        
        self.downloaded(from: endPoint, placeHolder: placeHolder)
    }
    
    func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.image = image
        }
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension VBVImageView{
    
    func render(image: UIImage){
        self.image = image.withRenderingMode(.alwaysOriginal)
    }
    
    func render(image: String, color: UIColor = UIColor.white) {
        
        if let img = UIImage(named: image){
            let newImage = img.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
            self.image = newImage
        }
    }
    
    //MARK:- download image
    
    func downloaded(from url: URL?, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFill, placeHolder: UIImage?) {
        
        if let image = placeHolder{
            self.image = image
        }
        
        guard let url = url else {return}
        self.activityIndicatorView.startAnimating()
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            
            var image: UIImage? = nil
            
            if self.isGIF(data: data), let img = self.gif(with: data){
                image = img
                VBVImageView.imageCache.setObject(img, forKey: url.lastPathComponent as AnyObject)
            }
            else if let img = UIImage(data: data){
                image = img
                VBVImageView.imageCache.setObject(img, forKey: url.lastPathComponent as AnyObject)
            }
            
            self.setImage(image)
        }.resume()
    }
    
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFill, placeHolder: UIImage?) {
        
        guard let link = link, let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, placeHolder: placeHolder)
    }
    
    //MARK:- GIFs
    
    func isGIF(data: Data) -> Bool {
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return false
        }
        
        let count = CGImageSourceGetCount(source)
        return count > 1
    }
    
    func gif(with data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return animatedImage(source)
    }
    
    func gif(with url: String) -> UIImage? {
        guard let bundleURL:URL = URL(string: url), let imageData = try? Data(contentsOf: bundleURL)
            else {
                print("image named \"\(url)\" doesn't exist")
                return nil
        }
        
        
        return gif(with: imageData)
    }
    
    func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif"), let imageData = try? Data(contentsOf: bundleURL) else {
                print("VBV: This image named \"\(name)\" does not exist")
                return nil
        }
        
        return gif(with: imageData)
    }
    
    func delayForImage(at index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        if delay < 0.1 { delay = 0.1 }
        
        return delay
    }
    
    func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    func animatedImage(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = delayForImage(at: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        return animation
    }
}
