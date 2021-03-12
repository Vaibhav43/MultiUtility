//
//  AlarmViewController.swift
//  Alarm
//
//  Created by apple on 11/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AlarmViewController: BaseViewController {
    
    @IBOutlet weak var resetButton: UIButton!{
        didSet{
            resetButton.setTitle("Reset", for: .normal)
            resetButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    @IBOutlet weak var timerView: VBVView!{
        didSet{
            timerView.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var startButton: UIButton!{
        didSet{
            startButton.backgroundColor = UIColor.Alarm.ktheme
            startButton.setTitleColor(.white, for: .normal)
            startButton.titleLabel?.addObserver(self, forKeyPath: "text", options: [.new], context: nil)
        }
    }
    
    var homeViewModel = AlarmViewModel()
    
    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.cornerRadius = .rounded
    }
    
    //MARK:- Instance
    
    class func instance(navigation: UINavigationController){
        
        let vc = AlarmViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    //MARK:- Setup
    
    func setHeader(){
        
        if tabBarController == nil{
            self.navigationItem.title = "Alarm"
            let backToList = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(backToOptions(_:)))
            self.navigationItem.leftBarButtonItem = backToList
        }
        else{
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
            self.tabBarController?.navigationItem.title = "Alarm"
        }
    }
    
    func setup(){
        
        self.homeViewModel.timerChanged = { [weak self] in
            self?.startButton.setTitle(self?.homeViewModel.timeInterval.diffstring, for: .normal)
        }
        
        self.homeViewModel.resetAll = { [weak self] in
            self?.resetValues()
        }
        
        self.homeViewModel.setup { [weak self] (success) in
            
            if success{
                self?.resetButton.isHidden = false
                self?.setPulsating()
            }
        }
    }
    
    func setPulsating(){
        timerView.pulsating = (self.homeViewModel.timeInterval == 0) ? nil : VBVView.Pulsating(fillColor: UIColor.Alarm.ktheme, animateTo: 1.2, animateFrom: 0.98, animateDuration: 1)
    }
    
    //MARK:- Reset
    
    func resetValues(){
        startButton.setTitle("Start", for: .normal)
        setPulsating()
        self.resetButton.isHidden = true
        UserDefaultsClass.delete(key: .alarmTime)
        Notifications.shared.remove(type: Notifications.Identifiers.identifier)
    }
    
    //MARK:- Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (object as? UIButton) == startButton && keyPath == "text"{
            self.startButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    //MARK:- Action Handling
    
    @IBAction func startClicked(_ sender: UIButton){
        
        let hourNumber = ["1", "2", "3", "4", "5", "6"]
        
        self.action_sheet(array: hourNumber, title: "Select Break Interval", completion: { (index) in
            
            Notifications.shared.scheduleNotification(hour: hourNumber[index].toInt)
            self.setup()
        })
    }
    
    @IBAction func resetClicked(_ sender: UIButton){
        resetValues()
    }
    
    @objc func backToOptions(_ sender: UIBarButtonItem){
        Session.setSession()
    }
}
