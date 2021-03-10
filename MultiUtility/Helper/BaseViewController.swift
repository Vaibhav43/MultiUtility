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
    @objc optional func videoSelected(url: URL?)
}

class BaseViewController: UIViewController, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate {
    
    /// gesture to remove keyboard when tapped the view
    var tapGesture = UITapGestureRecognizer()
    
    /// view for the management of textfields when keyboard appears
    var onView: UIView?
    
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
    
    //MARK:- keyboard functions
    
    /// initialize the view to manage for the keyboard
    ///
    /// - Parameters:
    ///   - tableView: for the cells
    ///   - onView: for the textfield
    ///   - buttonView: button on which transformation will work
    ///   - buttonConstraint: button whose bottom constrainsts will be managed
    func initiateKeyboard(onView: UIView? = nil, buttonView: UIView? = nil, addGesture: Bool = true){
        
        self.keyboardView = buttonView
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
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (gestureRecognizer.view == touch.view)
    }
    
    /// deinitialize the view to manage for the keyboard
    func deinitKeyboard(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        self.onView?.removeGestureRecognizer(tapGesture)
    }
    
    /// notification of keyboardWillShow will be received here
    @objc func keyboardWillShow(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        let height = keyboardFrame.height
        
        if keyboardView != nil{
            
            UIView.animate(withDuration: 0.3) {
                self.keyboardView?.transform = CGAffineTransform(translationX: 0, y: -height)
            }
        }
        
        if let onview = onView as? UIScrollView{
            
            onview.contentInset = contentInsets
            onview.scrollIndicatorInsets = contentInsets;
        }
        else if let onview = self.onView{
            
            onview.transform = CGAffineTransform(translationX: 0, y: -height)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// notification of keyboardWillHide will be received here
    @objc func keyboardWillHide(notification: NSNotification){
        
        if keyboardView != nil{
            
            UIView.animate(withDuration: 0.3) {
                self.keyboardView?.transform = .identity
            }
        }
        
        if let onview = self.onView as? UIScrollView{
            let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
            onview.contentInset = contentInsets
            onview.scrollIndicatorInsets = contentInsets;
        }
        else{
            self.onView?.transform = .identity
        }
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: header view
    
    func showHideHeader(hide: Bool = true){
        self.navigationController?.navigationBar.isHidden = hide
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
    
    func showAlertForImage(sender: UIView? = nil, viewController: UIViewController? = nil,cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.askForCameraPermission(cameraCaptureMode: cameraCaptureMode)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallery(cameraCaptureMode: cameraCaptureMode)
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
    
    func showPicker(source: UIImagePickerController.SourceType, captureMode: UIImagePickerController.CameraCaptureMode?){
        picker = UIImagePickerController()
        picker?.delegate = self
        picker?.sourceType = source
        
        ////this is the conditon when we have to open camera in video mode. Implemented in record screen for doctor app.
        if captureMode == .video{
            picker?.mediaTypes = [kUTTypeMovie as String]
            if source == .camera{
                picker?.cameraCaptureMode = .video
                picker?.videoQuality = .typeHigh
            }
           picker?.videoExportPreset = AVAssetExportPresetPassthrough
        }
        
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
    
    func openCamera(cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        
        DispatchQueue.main.async {
            
            guard (UIImagePickerController.isSourceTypeAvailable(.camera)) else {
                Toast.show(message: "Not able to access camera")
                return
            }
            
            self.showPicker(source: .camera, captureMode: cameraCaptureMode)
        }
    }
    
    func openGallery(cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        self.showPicker(source: .photoLibrary, captureMode: cameraCaptureMode)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            baseDelegate?.selected(image: image.wxCompress(type: .timeline), name: "image.jpg")
        } else if let videoURL = info[.mediaURL] as? URL{
            baseDelegate?.videoSelected?(url: videoURL)
        }
        
        self.resetPicker()
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.resetPicker()
    }
    
    func askForCameraPermission(cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch (status){
            case .authorized:
                self.openCamera(cameraCaptureMode: cameraCaptureMode)
                
            case .notDetermined:
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                    guard granted else{return}
                    self.openCamera(cameraCaptureMode: cameraCaptureMode)
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

//MARK:- Compression

extension BaseViewController{
    
    func compressURL(outputFileURL: URL, completion: @escaping ((Data?)->())) {
        guard let data = try? Data(contentsOf: outputFileURL) else {
            return
        }
        
        print(value: "File size before compression: \(Double(data.count / 1048576)) mb")
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { exportSession in
           
            guard let session = exportSession else {
                completion(nil)
                return
            }
            
            switch session.status {
            
            case .completed:
                guard let compressedData = try? Data(contentsOf: compressedURL) else {
                    return
                }
                
                print(value: "File size after compression: \(Double(compressedData.count / 1048576)) mb")
                completion(compressedData)
            default:
                completion(nil)
                break
            }
        }
    }
    
      func compressVideo(inputURL: URL,
                         outputURL: URL,
                         handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            handler(exportSession)
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
