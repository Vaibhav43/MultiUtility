//
//  UIElements.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 23/11/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension UINavigationController {
    
    func push<T>(storyboard: UIStoryboard, identifier: T.Type){
        
        guard let vc = storyboard.instantiate(identifier.self) as? UIViewController else{return}
        self.pushViewController(vc, animated: true)
    }
    
    func get(viewController: AnyClass) -> UIViewController?{
        
        for element in viewControllers where element.isKind(of: viewController){
            return element
        }
        
        return nil
    }
    
    func popTo(viewController: AnyClass) {
        
        for element in viewControllers where element.isKind(of: viewController){
            self.popToViewController(element, animated: true)
        }
    }
    
    func backButton(title: String?, image: String? = nil, tintColor: UIColor = UIColor.blue) {
        
        let backButton = UIBarButtonItem()
        backButton.title = title
        backButton.tintColor = tintColor
        navigationBar.topItem?.backBarButtonItem = backButton
        navigationBar.backItem?.backBarButtonItem = backButton
    }
    
    ///customize for dashboard stretcher
    func stretchy(color: UIColor, tint: UIColor, titleColor: UIColor?) {
        
        self.setNavigationBarHidden(false, animated: true)
        
        // color for button images, indicators and etc.
        self.navigationBar.tintColor = tint
        
        // color for background of navigation bar
        view.backgroundColor = color
        self.navigationBar.barTintColor = color
        self.navigationBar.isTranslucent = false
        
        if let titleColor = titleColor{
            // color for standard title label
            let attribute = [NSAttributedString.Key.foregroundColor: titleColor]
            self.navigationBar.titleTextAttributes = attribute
            self.navigationBar.largeTitleTextAttributes = attribute
        }
    }
}

extension NSLayoutConstraint {
    
    //    override open var description: String {
    //        let id = identifier ?? ""
    //        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    //    }
    
    func multiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIStoryboard{
        
    func instantiate<T>(_ identifier: T.Type) -> T {
        let identifier = String(describing: identifier)
        return instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func pushController<T>(viewcontroller: T.Type){
        
        guard let vc = self.instantiate(viewcontroller.self) as? UIViewController else {return}
        let nav = AppDelegate.navigation
        nav?.pushViewController(vc, animated: true)
    }
}

extension UIBarButtonItem{
    
    convenience init(title: String? = nil, attributed: NSMutableAttributedString? = nil, image: String? = nil, color: UIColor = UIColor.custom_appearance, target: AnyObject? = nil, action: Selector? = nil) {
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.tintColor = color
        
        if let attributed = attributed{
            button.setAttributedTitle(attributed, for: .normal)
        }
        
        if let action = action{
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        if let img = image{
            
            button.setImage(UIImage(named: img)?.resized(toWidth: 30), for: .normal)
        }
        
        self.init(customView: button)
    }
}

extension UIView{
    
    @IBInspectable var cornerRadius: CornerRadius {
        set { layer.cornerRadius = newValue.cornered(view: self) }
        get { return .none }
    }
    
    func set(cornerRadius: CornerRadius, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, backgroundColor: UIColor = .clear){
        
        if cornerRadius != .none{
            self.layer.cornerRadius = cornerRadius.cornered(view: self)
        }
        
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
    func addGradient(isVertical: Bool, colors: [UIColor]) {
        
        ///remove all layers before adding new
        layer.sublayers?.forEach({ (layer) in
            
            if layer is CAGradientLayer{
                layer.removeFromSuperlayer()
            }
        })
                 
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map({ $0.cgColor })
        
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        }
        else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeShadow() {
        
        self.layer.shadowOffset = CGSize(width: 0 , height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.00
        self.layer.shadowPath = nil
        self.layer.masksToBounds = true
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(radius: CGFloat, color: UIColor = .black, opacity: Float, cornerRadius: CGFloat = 5){
        
        self.layer.shadowColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addshadow(top: Bool = false, left: Bool  = false, bottom: Bool = false, right: Bool = false, shadowRadius: CGFloat = 2.0, opacity: Float) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    func removeBorder(){
        
        if let first = self.subviews.first(where: { $0.restorationIdentifier == "borderView"}){
            first.removeFromSuperview()
        }
    }
    
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black, rounded: Bool = false) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.restorationIdentifier = "borderView"
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    if rounded{
                        v.layer.cornerRadius = v.frame.height*0.2
                    }
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
    
    func textDropShadow(){
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.masksToBounds = false
    }
}

extension UIApplication {
    
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
    
    class var topViewController: UIViewController?{
        
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    //open setting of the particular app
    class func openAppSetting(){
        
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), self.shared.canOpenURL(settingsUrl) else {
                return
            }
            
            self.shared.open(settingsUrl, options: [:], completionHandler: nil)
            //            self.shared.open(settingsUrl, completionHandler: { (success) in
            //            })
        }
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

extension UIResponder {
    
    private static weak var _currentFirstResponder: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        
        return _currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}

extension WKWebView {
    
    // Call this function when WKWebView finish loading
    func createpdf() -> String {
        let pdfData = createPdfFile(formatter: self.viewPrintFormatter())
        return self.saveWebViewPdf(data: pdfData)
    }
    
    func createPdfFile(formatter: UIViewPrintFormatter) -> NSMutableData {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: bounds.origin.y, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(formatter, startingAtPageAt: 0)
        printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        self.bounds = originalBounds
        return printPageRenderer.generatePdfData()
    }
    
    // Save pdf file in document directory
    func saveWebViewPdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("webViewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

extension UIPrintPageRenderer {
    
    func generatePdfData() -> NSMutableData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()
        for pdfPage in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }
        UIGraphicsEndPDFContext();
        return pdfData
    }
}

extension UIImage{
    
    func add(text: String, color: UIColor = UIColor.white) -> UIImage?{
        
        let imageView = VBVImageView(image: self)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        let label = VBVLabel(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        label.padding = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = text
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0);
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return imageWithText
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /**
     Tint, Colorize image with given tint color<br><br>
     This is similar to Photoshop's "Color" layer blend mode<br><br>
     This is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved<br><br>
     white will stay white and black will stay black as the lightness of the image is preserved<br><br>
     - parameter tintColor: UIColor
     
     - returns: UIImage
     */
    func tintPhoto(_ tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(context.makeImage()!, in: rect)
        }
    }
    
    /**
     Tint Picto to color
     
     - parameter fillColor: UIColor
     
     - returns: UIImage
     */
    func tintPicto(_ fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage!, in: rect)
        }
    }
    
    /**
     Modified Image Context, apply modification on image
     
     - parameter draw: (CGContext, CGRect) -> ())
     
     - returns: UIImage
     */
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func render(image: UIImage) -> UIImage{
        
        let newImage = image.withRenderingMode(.alwaysOriginal)
        return newImage
    }
}
