//
//  ImagePickerDelegate.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 26/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK:- Instance
    
    ///picker reference for the image picker
    fileprivate var picker: UIImagePickerController?
    
    ///selected image or video url
    fileprivate var completion: ((UIImage?, URL?)->())?
    
    private static var privateShared: ImagePickerController?
    
    class var shared: ImagePickerController { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = ImagePickerController()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    //MARK:- Picker Actions
    
    func imagePicker(cameraCaptureMode: UIImagePickerController.CameraCaptureMode, source: UIImagePickerController.SourceType? = nil, sender: UIView? = nil, completion: ((UIImage?, URL?)->())?){
        
        if Thread.isMainThread{
            showPickerBy(cameraCaptureMode: cameraCaptureMode, source: source, sender: sender, completion: completion)
        }
        else{
            DispatchQueue.main.async {
                self.showPickerBy(cameraCaptureMode: cameraCaptureMode, source: source, sender: sender, completion: completion)
            }
        }
    }
    
    fileprivate func showPickerBy(cameraCaptureMode: UIImagePickerController.CameraCaptureMode, source: UIImagePickerController.SourceType? = nil, sender: UIView? = nil, completion: ((UIImage?, URL?)->())?){
        
        if let source = source{
            showPicker(source: source, captureMode: cameraCaptureMode)
        }
        else{
            self.openImagePicker(cameraCaptureMode: cameraCaptureMode, sender: sender, completion: completion)
        }
    }
    
    fileprivate func openImagePicker(cameraCaptureMode: UIImagePickerController.CameraCaptureMode, sender: UIView?, completion: ((UIImage?, URL?)->())?){
        
        guard let controller = UIApplication.topViewController else {return}
        self.completion = completion
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
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func openGallery(cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        showPicker(source: .photoLibrary, captureMode: cameraCaptureMode)
    }
    
    fileprivate func openCamera(cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        
        guard (UIImagePickerController.isSourceTypeAvailable(.camera)) else {
            Toast.show(message: "Not able to access camera")
            return
        }
        
        showPicker(source: .camera, captureMode: cameraCaptureMode)
    }
    
    fileprivate func showPicker(source: UIImagePickerController.SourceType, captureMode: UIImagePickerController.CameraCaptureMode?){
        
        guard let controller = UIApplication.topViewController else {return}
        
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
        
        if let top = UIApplication.topViewController(){
            top.present(picker!, animated: true, completion: nil)
        }
        else{
            controller.present(picker!, animated: true, completion: nil)
        }
    }
    
    fileprivate func dismiss(){
        picker?.dismiss(animated: true, completion: nil)
        ImagePickerController.destroy()
    }
    
    //MARK:- Picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            completion?(image, nil)
        }
        else if let videoURL = info[.mediaURL] as? URL{
            completion?(nil, videoURL)
        }
        else{
            completion?(nil, nil)
        }
        
        dismiss()
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        completion?(nil, nil)
        dismiss()
    }
    
    //MARK:- Permission
    
    fileprivate func askForCameraPermission(cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil){
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch (status){
        case .authorized:
            openCamera(cameraCaptureMode: cameraCaptureMode)
            
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
    
    fileprivate func askForGalleryPhotos(completion: ((Bool?)->())? = nil){
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
    
    fileprivate func camDenied(type: String){
        
        guard let controller = UIApplication.topViewController else {return}
        
        guard UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) else {return}
        
        controller.alert(title: "Requires Permission", message: "Seems like you have initially denied \(type) permission. Please click on Go to allow app to access your \(type).\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the \(type) on.\n\n3. Open this app and try again.", defaultButton: "Go", cancelButton: "Cancel") { (value) in
            
            guard value else{return}
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}
