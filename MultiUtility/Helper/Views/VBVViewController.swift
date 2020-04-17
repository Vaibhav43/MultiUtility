//
//  BaseViewController.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 14/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit

protocol VBVDelegate{
    
    func selected(image: UIImage, name: String)
}

class VBVViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    
    /// gesture to remove keyboard when tapped the view
    lazy var tapGesture = UITapGestureRecognizer()
    
    /// tableview for the management of cells when keyboard appears
    var scrollView: UIScrollView?
    
    /// view for the management of textfields when keyboard appears
    var onView: UIView?
    
    /// to allow sidemenu to open or not
    lazy var shouldOpenSideMenu = true
    
    /// image picker to allow user to pick images
    lazy var picker = UIImagePickerController()
    
    /// a delegate of the VBVViewController to provide its functions espeacially imagepicker
    var baseDelegate: VBVDelegate?
    
    /// a delegate of the UIDocumentInteractionController to provide its functions espeacially documents
    lazy var documentInteractionController = UIDocumentInteractionController()
    
    
    //MARK:- lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitKeyboard()
    }
    
    //MARK:- keyboard functions
    
    
    /// initialize the view to manage for the keyboard
    ///
    /// - Parameters:
    ///   - tableView: for the cells
    ///   - onView: for the textfield
    ///   - buttonView: button on which transformation will work
    ///   - buttonConstraint: button whose bottom constrainsts will be managed
    func initiateKeyboard(scrollView: UIScrollView? = nil, onView: UIView? = nil){
        
        self.scrollView = scrollView
        self.onView = onView
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.cancelsTouchesInView = false
        
        if scrollView == nil{
            onView?.addGestureRecognizer(tapGesture)
        }
        else{
            self.scrollView?.addGestureRecognizer(tapGesture)
        }
    }
    
    /// deinitialize the view to manage for the keyboard
    func deinitKeyboard(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        scrollView?.removeGestureRecognizer(tapGesture)
        onView?.removeGestureRecognizer(tapGesture)
        scrollView = nil
        onView = nil
    }
    
    /// notification of keyboardWillShow will be received here
    @objc func keyboardWillShow(notification: NSNotification){
        
        keyboardWillHide(notification: notification)
        let userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        
        if scrollView != nil {
            
            scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets;
        }
        else if self.onView != nil{
            
            UIView.animate(withDuration: 0.2) {
                self.onView?.frame.origin.y -= keyboardFrame.height/2
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// notification of keyboardWillHide will be received here
    @objc func keyboardWillHide(notification: NSNotification){
        
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        
        if scrollView != nil{
            scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets;
        }
        else{
            self.onView?.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: button handling
    
    @objc func backPressed(){
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func popToRoot(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- document functions
    
    func share(url: URL, view: UIView) {
        
        documentInteractionController.delegate = self
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        
        if #available(iOS 11.0, *) {
            documentInteractionController.presentPreview(animated: true)
        } else {
            
            if let bookURL = URL(string:"itms-books:"), UIApplication.shared.canOpenURL(bookURL){
                documentInteractionController.presentOptionsMenu(from: .zero, in: view, animated: true)
            }
            else{
                documentInteractionController.presentPreview(animated: true)
            }
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        guard let navVC = self.navigationController else {
            return self
        }
        
        return navVC
    }
}

//MARK:- image functions

extension VBVViewController{
    
    func alertForImage(){
        
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        if let top = UIApplication.topViewController{
            top.present(alert, animated: true, completion: nil)
        }
        else{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            if self.navigationController != nil{
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        else{
            Toast.show(message: "Not able to access camera")
        }
    }
    
    func openGallery(){
        
        if self.navigationController != nil{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if let nav = AppDelegate.navigation{
            nav.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.1), let newImage = UIImage(data: data){
            baseDelegate?.selected(image: newImage, name: "image.png")
        }
        
        if self.navigationController != nil{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension VBVViewController{
    
    //MARK: header view
    
    func showHideHeader(hide: Bool = true){
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
    }
}

extension UIViewController{

    func getNavigationController(controller: UIViewController) -> UINavigationController{
        
        let navigation = UINavigationController(rootViewController: controller)
        
        if #available(iOS 13, *) {
            navigation.modalPresentationStyle = .automatic
        } else {
            navigation.modalPresentationStyle = .custom
        }
        
        navigation.navigationBar.tintColor = UIColor.custom_appearance
        return navigation
    }
    
    func present(completion: (() -> Void)? = nil){
        
        let navigation = getNavigationController(controller: self)
        UIApplication.topViewController?.present(navigation, animated: true, completion: completion)
    }
    
    //MARK:- computed properties
    
    var safeAreaTopPadding: CGFloat{
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.top
        } else {
            return topLayoutGuide.length
        }
    }
    
    var safeAreaBottomPadding: CGFloat{
        
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    static var initFromNib: Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
    
    func share(text: String?, image: UIImage?){
        
        var items = [Any]()
        
        if let str = text{
            items.append(str)
        }
        
        if let img = image{
            items.append(img)
        }
        
        let activityViewController = UIActivityViewController(activityItems: items , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func alert_controller(array: [String], title: String, completion: ((Int) -> Void)?){
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let closure = { (action: UIAlertAction!) -> Void in
            let index = alert.actions.firstIndex(of: action)
            
            if index != nil {
                NSLog("Index: \(index!)")
                completion!(index!)
            }
        }
        
        for string in array{
            
            let action = UIAlertAction(title: string, style: .default, handler: closure)
            //  action.setValue(0, forKey: "titleTextAlignment")
            action.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)
        
        if let view = alert.view{
            
            let height:NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)//self.view.frame.height * 0.65)
            let width:NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 0.6)
            alert.view.addConstraint(height);
            alert.view.addConstraint(width);
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alert(title: String, message: String, defaultButton: String?, cancelButton: String?, completion: @escaping ((Bool) -> Void)){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let text = defaultButton{
            alertController.addAction(UIAlertAction(title: text, style: .default, handler: { (alert) in
                completion(true)
            }))
        }
        
        if let text = cancelButton{
            alertController.addAction(UIAlertAction(title: text, style: .default, handler: { (alert) in
                completion(false)
            }))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithTextView(title: String?, message: String?, donetitle: String, text: String? = nil, preferredStyle: UIAlertController.Style, completion: @escaping (String?) -> Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let customView = UITextView()
        customView.font = UIFont.systemFont(ofSize: 14)
        customView.set(cornerRadius: .mild, borderWidth: 1.0, borderColor: UIColor.lightGray, backgroundColor: .white)
        customView.text = text
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        customView.frame = controller.view.frame
        controller.view.addSubview(customView)
        alertController.setValue(controller, forKey: "contentViewController")
        
        let leadConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .leading, relatedBy: .equal, toItem: customView, attribute: .leading, multiplier: 1.0, constant: -15)
        let trailConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .trailing, relatedBy: .equal, toItem: customView, attribute: .trailing, multiplier: 1.0, constant: 15)
        let topConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .top, relatedBy: .equal, toItem: customView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .bottom, relatedBy: .equal, toItem: customView, attribute: .bottom, multiplier: 1.0, constant: 50)
        let heightConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.3)
        NSLayoutConstraint.activate([leadConstraint, trailConstraint, topConstraint, bottomConstraint, heightConstraint])
        
        let save = UIAlertAction(title: donetitle, style: .default, handler: {(alert: UIAlertAction!) in
            completion(customView.text)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
            completion(nil)
        })
        
        alertController.addAction(save)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
            customView.becomeFirstResponder()
        }
    }
    
    func alertWithTextfield(title: String?, message: String?, placeHolder: String?, preferredStyle: UIAlertController.Style, completion: @escaping (UITextField) -> Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = ""
        }
        
        let saveAction = UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            completion(firstTextField)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func action_sheet(array: [String], images:[String]? = nil, title: String, completion: ((Int) -> Void)?){
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = .white
        alertContentView.layer.cornerRadius = 10
        alertContentView.alpha = 1
        //alertContentView.layer.borderWidth = 1
        //alertContentView.layer.borderColor = BorderColor.CGColor
        
        let closure = { (action: UIAlertAction!) -> Void in
            let index = alert.actions.firstIndex(of: action)
            
            if index != nil {
                //                NSLog("Index: \(index!)")
                completion!(index!)
            }
        }
        
        for (i, string) in array.enumerated(){
            
            let action = UIAlertAction(title: string, style: .default, handler: closure)
            //  action.setValue(0, forKey: "titleTextAlignment")
            action.setValue(UIColor.custom_appearance, forKey: "titleTextColor")
            
            if let images = images, images.count>i, let image = UIImage(named: images[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal){
                action.setValue(UIColor.black, forKey: "titleTextColor")
                action.setValue(image, forKey: "image")
            }
            
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        if array.count > 6, let view = alert.view{
            
            let height:NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.65)
            let width:NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 1.0)
            alert.view.addConstraint(height);
            alert.view.addConstraint(width);
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
