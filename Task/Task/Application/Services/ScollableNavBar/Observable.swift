//
//  Observable.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

 class Observable<Value>: NSObject {
   var observer: ((Value) -> Void)?
}

 class KVObservable<Value>: Observable<Value> {
  private let keyPath: String
  private weak var object: AnyObject?
  private var observingContext = NSUUID().uuidString
  
   init(keyPath: String, object: AnyObject) {
    self.keyPath = keyPath
    self.object = object
    super.init()
    
    object.addObserver(self, forKeyPath: keyPath, options: [.new], context: &observingContext)
  }
  
  deinit {
    object?.removeObserver(self, forKeyPath: keyPath, context: &observingContext)
  }
  
    //метод срабатывающий когда проиходит измения значения в наблюдаемом объекте
    
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &observingContext, let newValue = change?[NSKeyValueChangeKey.newKey] as? Value
        else { return }

    observer?(newValue)
  }
}

