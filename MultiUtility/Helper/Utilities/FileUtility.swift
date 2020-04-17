//
//  FileUtility.swift
//  VBVFramework
//
//  Created by apple on 14/06/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation
import UIKit

class FileUtility{
    
    //MARK:- Path
    
    class func documentDirectory(path: String = Path.internalFolder.rawValue) -> URL{
        
        let fileManager = FileManager.default
        let documentsUrl: URL = { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! }()
        let directoryPath: URL = { documentsUrl.appendingPathComponent(path) }()
        
        if !fileManager.fileExists(atPath: directoryPath.path){
            try! fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return directoryPath
    }
    
    //MARK:- clear
    
    //clear the documentory folder to free up the space using the extension of files
    class func clearTempFolder(ext: String, completion: (()-> ())?) {
        
        DispatchQueue.main.async {
            let path = FileUtility.documentDirectory()
            guard let items = try? FileManager.default.contentsOfDirectory(atPath: path.path) else { return }
            
            for item in items where item.contains(ext) {
                let completePath = path.path.appending("/").appending(item)
                try? FileManager.default.removeItem(atPath: completePath)
            }
            
            completion?()
        }
    }
    
    //MARK:- save
    
    class func saveImage(image: UIImage, directory: String = Path.internalFolder.rawValue, name: String? = nil) -> String? {
        
        // get the documents directory url
        let documentsDirectory = FileUtility.documentDirectory(path: directory)
        let date = Date().toString(format: .ddMMyyyyHHmmss)
        
        // choose a name for your image
        var fileName = ""
        
        if let name = name{
            fileName = name
        }
        else{
            fileName = "image\(date).jpg"
        }
        
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        
        if let data = image.jpegData(compressionQuality: 1){
            
            if !FileManager.default.fileExists(atPath: fileURL.path){
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print(value:"file saved")
                    return fileURL.path
                } catch {
                    print(value:"error saving file: \(error)")
                }
            }
        }
        
        return nil
    }
    
    class func saveFile(from data: Data, name: String, directory: String, completion: ((URL?)->())?){
        DispatchQueue.main.async {
            
            let resourceDocPath = FileUtility.documentDirectory(path: directory)
            let actualPath = resourceDocPath.appendingPathComponent(name)
            
            if !FileManager.default.fileExists(atPath: actualPath.path){
                do {
                    try data.write(to: actualPath, options: .atomicWrite)
                    print(value: "file successfully saved!")
                    completion?(actualPath)
                } catch {
                    completion?(nil)
                    print(value: "file could not be saved")
                }
            }
        }
    }
    
    /// save multiple images in the document directory as normal for loop doesn't works properly and needs some delay
    ///
    /// - Parameters:
    ///   - imageArray: array of images
    ///   - path: where image needs to be saved
    class func saveImages(imageArray: [UIImage], names: [String]? = nil, showLoader: Bool = false, hideLoader: Bool = false, directory: String, completion: @escaping (([String])->())){
        
        var pathArray = [String]()
        
        if showLoader{
            LoaderView.shared.show(with: "Please wait...\nSaving Files", type: .spinner)
        }
        
        if imageArray.isEmpty{
            
            if hideLoader{
               LoaderView.shared.hide()
            }
            
            completion(pathArray)
            return
        }
        
        let asyncOperation = AsyncOperation(numberOfSimultaneousActions: 1, dispatchQueueLabel: "imageSaving")
        
        asyncOperation.whenCompleteAll = {
            DispatchQueue.main.async {
                if hideLoader{
                    LoaderView.shared.hide()
                }
                
                completion(pathArray)
            }
        }
        
        for (index, image) in imageArray.enumerated(){
            
            asyncOperation.run { (completeClosure) in
                
                var name: String? = nil
                
                if let names = names, !names.isEmpty{
                    name = names[index]
                }
                
                DispatchQueue.global(qos: .utility).async {
                    
                    let url = FileUtility.saveImage(image: image, directory: directory, name: name)
                    if let filePath = url?.components(separatedBy: "/").last{
                        pathArray.append(filePath)
                    }
                    sleep(1)
                    completeClosure()
                }
            }
        }
    }
    
    class func file(path: String, directory: String = Path.internalFolder.rawValue) -> UIImage?{
        
        let dirPath = FileUtility.documentDirectory(path: directory)
        let name = "/" + path
        let imagePath = dirPath.path.appending(name)
        let image    = UIImage(contentsOfFile: imagePath)
        return image
    }
    
    class func fileExists(name: String, directory: String = Path.internalFolder.rawValue) -> Bool{
        
        // get the documents directory url
        let documentsDirectory = FileUtility.documentDirectory(path: directory)
        let fileURL = documentsDirectory.appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: fileURL.path){
            return true
        }
        
        return false
    }
    
    //MARK:- fetch functions
    
    class func fetchData(directory: String, name: String) -> Data?{
        
        let resourceDocPath = FileUtility.documentDirectory(path: directory)
        let actualPath = resourceDocPath.appendingPathComponent(name)
        let data = try? Data.init(contentsOf: actualPath)
        return data
    }
    
    class func fetchData(path: String) -> Data?{
        
        if let url = URL(string: path){
            let data = try? Data.init(contentsOf: url)
            return data
        }
        
        return nil
    }
    
    class func path(name: String, folder: String) -> URL?{
        
        if FileUtility.fileExists(name: name, directory: folder){
            let resourceDocPath = FileUtility.documentDirectory(path: folder)
            let actualPath = resourceDocPath.appendingPathComponent(name)
            return actualPath
        }
        
        return nil
    }
    
    //MARK:- pdf functions
    
    class func savePdf(from url: String, name: String, directory: String, completion: ((URL?)->())?){
        
        if let data = fetchData(path: url){
            saveFile(from: data, name: name, directory: directory, completion: { (url) in
                completion?(url)
            })
        }
        
        completion?(nil)
    }
}
