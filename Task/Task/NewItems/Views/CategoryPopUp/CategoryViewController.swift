//
//  CategoryViewController.swift
//  Task
//
//  Created by Азизбек on 10.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UIPickerViewDelegate {
    let setCategoryNotificationID = "ru.azizbek.setCategoryNotificationID"

    let listViewController = ListViewController()
    var arrayOfNames = [String]()
    var choosenCategory = ""
    var nameObservation: NSKeyValueObservation?
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerOutlet.dataSource = self
        pickerOutlet.delegate = self
        CoreDataService.shared.fetchLists {[weak self] (lists) in
            for list in lists {
                guard let name = list.name else { return }
                self?.arrayOfNames.append(name)
            }
        }
        
    }


    @IBAction func doneAction(_ sender: UIButton) {
        self.view.removeFromSuperview()
        
        UserDefaults.standard.set(choosenCategory, forKey: "choosenCategory")
        print(choosenCategory)
        didChooseCategory()
    }

    func didChooseCategory() {
        NotificationCenter.default.post(name: NSNotification.Name(setCategoryNotificationID), object: self)
    }

}
extension CategoryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosenCategory = arrayOfNames[row]
    }

}
