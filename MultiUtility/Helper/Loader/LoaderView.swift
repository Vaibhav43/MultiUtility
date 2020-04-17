//
//  LoaderView.swift
//  EcommerceFashionDesign
//
//  Created by Vaibhav Agarwal on 16/06/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    enum LoaderType: String, CaseIterable {
        case pulsatingLoader
        case clipRotate
        case pulsating
        case rotatingBall
        case bouncingBall
        case ballClipPulsating
        case ballClipPulsatingMultiple
        case spinner
        case spinnerDot
        case spinnerStar
        case spinnerBallRotate
    }
    
    //MARK:- properties
    
    lazy var messageLabel:UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var spinnerView: SpinnerView = {
        
        let activity = SpinnerView()
        activity.backgroundColor = UIColor.clear
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    //MARK:- variables
    
    static let shared = LoaderView()
    var loader: LoaderView?
    
    var loaderType: LoaderType = .spinner{
        didSet{
            self.setNeedsDisplay()
            setLoader()
        }
    }
    
    //MARK:- functions
    
    func show(type: LoaderType){
        
        if loader == nil{
            loader = LoaderView.shared
        }
        
        DispatchQueue.main.async {
            if let window = AppDelegate.instance.window{
                self.loader!.frame = window.bounds
                window.addSubview(self.loader!)
                self.loaderType = type
            }
        }
    }
    
    func show(with message: String, type: LoaderType){
        
        if loader == nil{
            loader = LoaderView.shared
        }
        self.addMessagge()
        DispatchQueue.main.async {
            
            self.loader?.frame = UIScreen.main.bounds
            self.loader?.messageLabel.text = message
            
            if let window = AppDelegate.instance.window{
                window.addSubview(self.loader!)
                self.loaderType = type
            }
        }
    }
    
    func hide(){
        
        hideLoader()
        
        if self.loader != nil && self.loader?.superview != nil{
            self.loader?.removeFromSuperview()
            self.loader = nil
        }
    }
    
    //MARK:- setup
    
    func setLoader(){
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        let size = CGSize(width: 50, height: 50)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+4.0) {
            self.hide()
        }
        
        switch loaderType {
            
        case .spinner:
            addConstraints()
            
        case .pulsatingLoader:
            PulsatingLoader.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .rotatingBall:
            RotatingBall.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .clipRotate:
            BallClipRotate.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .pulsating:
            PulsatingBall.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .bouncingBall:
            BouncingBall.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .ballClipPulsating:
            BallClipPulsating.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .ballClipPulsatingMultiple:
            BallClipPulsatingMultiple.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .spinnerStar:
            SpinnerStar.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .spinnerDot:
            SpinnerDot.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
            
        case .spinnerBallRotate:
            SpinnerBallRotate.shared.configure(in: self.layer, size: size, color: UIColor.systemPink)
        }
    }
    
    func hideLoader(){
        
        switch loaderType {
            
        case .spinner:
            messageLabel.removeFromSuperview()
            spinnerView.removeFromSuperview()
            
        default:
            self.hide(layer: self.layer)
        }
    }
}

extension LoaderView{
    
    func hide(layer: CALayer){
        
        layer.sublayers?.forEach({ (lay) in
            
            if let name = lay.name, name.contains("circle"){
                lay.removeFromSuperlayer()
            }
        })
    }
}

//MARK:- spinner

extension LoaderView{
    
    func addConstraints(){
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            spinnerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            spinnerView.heightAnchor.constraint(equalToConstant: 70),
            spinnerView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func addMessagge(){
        
        self.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
