//
//  BaseViewController.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 14/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit
import SafariServices
import Photos
import MobileCoreServices

@objc protocol BaseDelegate{
    func selected(image: UIImage, name: String)
    @objc optional func pdf(url: URL?)
}

class BaseViewController: UIViewController, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate {
    
    /// gesture to remove keyboard when tapped the view
    var tapGesture = UITapGestureRecognizer()
    
    /// tableview for the management of cells when keyboard appears
    var topTableView: UITableView?
    
    /// view for the management of textfields when keyboard appears
    var onView: UIView?
    
    /// button bottom constraints for the management of textfields when keyboard appears
    var keyboardButtonConstraint: NSLayoutConstraint?
    
    /// view for the management of textfields when keyboard appears.. it translates
    var keyboardView: UIView?
    
    /// to allow sidemenu to open or not
    var shouldOpenSideMenu = true
    
    /// image picker to allow user to pick images
    var picker: UIImagePickerController?
    
    /// a delegate of the Baseviewcontroller to provide its functions espeacially imagepicker
    var baseDelegate: BaseDelegate?
    
    var safari: SFSafariViewController?
    
    /// a delegate of the UIDocumentInteractionController to provide its functions espeacially documents
    var documentInteractionController: UIDocumentInteractionController?
    
    //MARK:- lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(value: "class name ------>>>> \(self.classForCoder)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK:- keyboard functions
    
    /// initialize the view to manage for the keyboard
    ///
    /// - Parameters:
    ///   - tableView: for the cells
    ///   - onView: for the textfield
    ///   - buttonView: button on which transformation will work
    ///   - buttonConstraint: button whose bottom constrainsts will be managed
    func initiateKeyboard(tableView: UITableView? = nil, onView: UIView? = nil, buttonView: UIView? = nil, buttonConstraint: NSLayoutConstraint? = nil, addGesture: Bool = true){
        
        self.keyboardView = buttonView
        self.keyboardButtonConstraint = buttonConstraint
        self.topTableView = tableView
        self.onView = onView
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if addGesture{
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            tapGesture.cancelsTouchesInView = false
            tapGesture.delegate = self
            
            if onView != nil{
                onView?.addGestureRecognizer(tapGesture)
            }
            else if topTableView != nil{
                self.topTableView?.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (gestureRecognizer.view == touch.view)
    }
    
    /// deinitialize the view to manage for the keyboard
    func deinitKeyboard(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        self.topTableView?.removeGestureRecognizer(tapGesture)
        self.onView?.removeGestureRecognizer(tapGesture)
    }
    
    
    /// notification of keyboardWillShow will be received here
    @objc func keyboardWillShow(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        let curFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        var height = keyboardFrame.height
        
        if keyboardView != nil{
            
            UIView.animate(withDuration: 0.3) {
                self.keyboardView?.transform = CGAffineTransform(translationX: 0, y: -height)
            }
        }
        else if keyboardButtonConstraint != nil && (keyboardButtonConstraint?.constant)! < height{
            
            if let heightBtn = keyboardButtonConstraint?.identifier, let doubleValue = Double(heightBtn){
                self.keyboardButtonConstraint?.constant = CGFloat(doubleValue).finiteValue
                height += CGFloat(doubleValue)
            }
            else{
                keyboardButtonConstraint?.identifier = "\(keyboardButtonConstraint?.constant ?? 0)"
                height += (keyboardButtonConstraint?.constant ?? 0)
            }
            
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.3) {
                    self.keyboardButtonConstraint?.constant = height.finiteValue
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        if topTableView != nil {
            
            topTableView?.contentInset = contentInsets
            topTableView?.scrollIndicatorInsets = contentInsets;
        }
        else if onView is UIScrollView{
            
            (onView as! UIScrollView).contentInset = contentInsets
            (onView as! UIScrollView).scrollIndicatorInsets = contentInsets;
        }
        else if self.onView != nil{
            
            let new = (height - curFrame.height)
            self.onView?.transform = CGAffineTransform(translationX: 0, y: -new)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// notification of keyboardWillHide will be received here
    @objc func keyboardWillHide(notification: NSNotification){
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        
        if keyboardButtonConstraint != nil{
            
            if let height = keyboardButtonConstraint?.identifier{
                let float = CGFloat(Double(height) ?? 0)
                keyboardButtonConstraint?.identifier = nil
                UIView.animate(withDuration: 0.3) {
                    self.keyboardButtonConstraint?.constant = float.finiteValue
                    self.view.layoutIfNeeded()
                }
            }
            else{
                keyboardButtonConstraint?.constant = 0
            }
        }
        else if keyboardView != nil{
            
            UIView.animate(withDuration: 0.3) {
                self.keyboardView?.transform = .identity
            }
        }
        
        if topTableView != nil{
            topTableView?.contentInset = contentInsets
            topTableView?.scrollIndicatorInsets = contentInsets;
        }
        else if onView is UIScrollView{
            
            (onView as! UIScrollView).contentInset = contentInsets
            (onView as! UIScrollView).scrollIndicatorInsets = contentInsets;
        }
        else{
            self.onView?.transform = .identity
            //            self.onView?.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: header view
    
    func backButton(title: String?, image: String? = nil, tintColor: UIColor = UIColor.lightGray) {
        
        let backButton = UIBarButtonItem()
        backButton.title = title
        backButton.tintColor = tintColor
        backButton.target = self
        backButton.action = #selector(backPressed)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func showHideHeader(hide: Bool = true){
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
    }
    
    //MARK: button handling
    
    @IBAction func backPressed(){
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func popToRoot(){
        
        #if PATIENT
        GlobalFunctions.Landing.popToRoot()
        #endif
        
    }
    
    //MARK:- safari functions
    
    func showSafari(url: URL?){
        
        if let url = url, safari == nil{
            
            safari = SFSafariViewController(url: url)
            safari?.delegate = self
            self.present(safari!, animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        safari = nil
    }
}

//MARK:- image functions

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showAlertForImage(sender: UIView? = nil, viewController: UIViewController? = nil){
        
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.askForCameraPermission()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        
        if UIDevice.current.isIPad, let sender = sender, let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        if let presentingCon = viewController{
            presentingCon.present(alert, animated: true, completion: nil)
        }
        else{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showPicker(source: UIImagePickerController.SourceType){
        picker = UIImagePickerController()
        picker?.delegate = self
        picker?.sourceType = source
        
        if self.navigationController != nil{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if let top = UIApplication.topViewController(){
            top.present(self.picker!, animated: true, completion: nil)
        }
        else{
            self.present(self.picker!, animated: true, completion: nil)
        }
    }
    
    func resetPicker(){
        
        if self.navigationController != nil{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        picker?.dismiss(animated: true, completion: nil)
        picker?.delegate = nil
        picker = nil
    }
    
    func openCamera(){
        
        DispatchQueue.main.async {
            
            guard (UIImagePickerController.isSourceTypeAvailable(.camera)) else {
                Toast.show(message: "Not able to access camera")
                return
            }
            
            self.showPicker(source: .camera)
        }
    }
    
    func openGallery(){
        self.showPicker(source: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            baseDelegate?.selected(image: image.wxCompress(type: .timeline), name: "image.jpg")
        }
        
        self.resetPicker()
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.resetPicker()
    }
    
    func askForCameraPermission(){
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch (status){
        case .authorized:
            self.openCamera()
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                guard granted else{return}
                self.openCamera()
            }
            
        case .denied:
            self.camDenied(type: "Camera")
            
        case .restricted:
            Toast.show(message: "Not able to access camera")

        @unknown default: break
        }
    }
    
    func askForGalleryPhotos(completion: ((Bool?)->())? = nil){
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            
        case .authorized:
            completion?(true)
            
        case .denied:
            self.camDenied(type: "Photos")
            completion?(nil)
            
        case .notDetermined:
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                completion?((newStatus == PHAuthorizationStatus.authorized))
            })
            
        default:
            completion?(nil)
        }
    }
    
    func camDenied(type: String){
        
        DispatchQueue.main.async{
            guard UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) else {return}
                        
            self.alert(title: "Requires Permission", message: "Seems like you have initially denied \(type) permission. Please click on Go to allow app to access your \(type).\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the \(type) on.\n\n3. Open this app and try again.", defaultButton: "Go", cancelButton: "Cancel") { (value) in
                
                guard value else{return}
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
        }
    }
}

//MARK:- document reading functions

extension BaseViewController: UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate{
    
    func documentController(url: URL, view: UIView?) {
        
        documentInteractionController = UIDocumentInteractionController()
        documentInteractionController?.delegate = self
        documentInteractionController?.url = url
        documentInteractionController?.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController?.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController?.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        if let navVC = self.navigationController{
            self.navigationController?.backButton(title: "Back")
            return navVC
        }
        else if let navVC = UIApplication.topViewController(){
            return navVC
        }
        
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        documentInteractionController = nil
    }
    
    //iCLOUd
    func showDocumentPicker(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        if let top = UIApplication.topViewController(){
            top.present(importMenu, animated: true, completion: nil)
        }
        else{
            self.present(importMenu, animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        if self.navigationController != nil{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        baseDelegate?.pdf?(url: myURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        if self.navigationController != nil{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
