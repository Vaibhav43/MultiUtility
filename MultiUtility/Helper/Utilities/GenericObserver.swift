//
//  GenericObserver.swift
//  Alarm
//
//  Created by apple on 12/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class GenericObserverDataSource<T>: NSObject {
    /**      This model holds the data of all assembly eligible products      */
    var data: GenericObserver<[T]> = GenericObserver([])
}

class GenericObserver<T> {
    
    typealias CompletionHandler = ((T) -> Void)
    
    var index: Int?
    
    var value : T {
        didSet {
            //            getIndex(old: oldValue, new: value)
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        //        self.notify()
    }
    
    //    func getIndex(old: T, new: T){
    //        print(old)
    //        print(new)
    //    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
}
