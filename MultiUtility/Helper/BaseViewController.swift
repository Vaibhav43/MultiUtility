//
//  BaseViewController.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 14/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

@objc protocol BaseDelegate{
    @objc optional func pdf(url: URL?)
}

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    /// gesture to remove keyboard when tapped the view
    var tapGesture = UITapGestureRecognizer()
    
    /// view for the management of textfields when keyboard appears
    var onView: UIView?
    
    /// view for the management of textfields when keyboard appears.. it translates
    var keyboardView: UIView?
    
    /// to allow sidemenu to open or not
    var shouldOpenSideMenu = true
    
    /// a delegate of the Baseviewcontroller to provide its functions espeacially imagepicker
    var baseDelegate: BaseDelegate?
    
    
    
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
    
    func compressVideo(inputURL: URL, outputURL: URL, handler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        
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
