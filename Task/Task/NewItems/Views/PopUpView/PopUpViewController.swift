//
//  PopUpViewController.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    let setDateNotificationID = "ru.azizbek.setDateComplitedNotificationID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveIn()
        datePicker.minimumDate = Date()
        

    }
    @IBAction func done(_ sender: UIButton) {
        moveOut()
        let choosenDate = datePicker.date
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        let dateString = dateFormatter.string(from: choosenDate)
        UserDefaults.standard.set(dateString, forKey: "choosenDate")
        print(dateString)
        didFinishSetDate()
    }
    
    
    func moveIn() {
          self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
          self.view.alpha = 0.0
          
          UIView.animate(withDuration: 0.24) {
              self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
              self.view.alpha = 1.0
          }
      }
      func moveOut() {
          UIView.animate(withDuration: 0.24, animations: {
              self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
              self.view.alpha = 0.0
          }) { _ in
              self.view.removeFromSuperview()
          }
      }
    
    func didFinishSetDate() {
        NotificationCenter.default.post(name: NSNotification.Name(setDateNotificationID), object: self)
    }
}

