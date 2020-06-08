//
//  GestureStateObservable.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class GestureStateObservable: Observable<UIGestureRecognizer.State> {
  private weak var gestureRecognizer: UIGestureRecognizer?
  
   init(gestureRecognizer: UIGestureRecognizer) {
    self.gestureRecognizer = gestureRecognizer
    super.init()
    
    gestureRecognizer.addTarget(self, action: #selector(self.handleEvent(_:)))
  }
  
  deinit {
    gestureRecognizer?.removeTarget(self, action: #selector(self.handleEvent(_:)))
  }
  
  @objc private func handleEvent(_ recognizer: UIGestureRecognizer) {
    observer?(recognizer.state)
  }
}
