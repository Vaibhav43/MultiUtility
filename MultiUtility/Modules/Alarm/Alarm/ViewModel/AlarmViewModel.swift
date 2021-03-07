//
//  AlarmViewModel.swift
//  Alarm
//
//  Created by apple on 12/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class AlarmViewModel{
    
    //MARK:- Closures
    
    var resetAll: (()->())?
    var timerChanged: (()->())?
    
    //MARK:- Properties
    
    var timeInterval: TimeInterval = 0
    
    ///to fetch the scheduled alarm time
    var scheduledTimeInterval: TimeInterval?{
        
        guard let date = UserDefaultsClass.get(key: .alarmTime) as? Date else{
            return nil
        }
        
        let interval = date.timeIntervalSince(Date())
        return (interval > 0) ? interval : nil
    }
    
    //MARK:- Setup
    
    func setup(completion: ((Bool)->())){
        
        guard let compo = scheduledTimeInterval else {
            self.resetValues()
            completion(false)
            return
        }
        
        self.timeInterval = compo
        setTimer()
        completion(true)
    }
    
    func setTimer(){
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            guard self.timeInterval > 0 else {
                timer.invalidate()
                self.resetValues()
                return
            }
            
            self.timerChanged?()
            self.timeInterval -= 1
        }
    }
    
    //MARK:- Reset
    
    func resetValues(){
        self.timeInterval = 0
        self.resetAll?()
    }
}
