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
    var choosenCategory = "Work"
    var nameObservation: NSKeyValueObservation?
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataService.shared.fetchLists {[weak self] (lists) in
            for list in lists {
                if list.name == "All"{
                    continue
                }else {
                    guard let name = list.name else { return }
                    self?.arrayOfNames.append(name)
                }
                
            }
        }
        DispatchQueue.main.async {
            self.pickerOutlet.selectRow(0, inComponent: 0, animated: true)
        }
        pickerOutlet.dataSource = self
        pickerOutlet.delegate = self
        
    }


    @IBAction func doneAction(_ sender: UIButton) {
        self.view.removeFromSuperview()
        
        UserDefaults.standard.set(choosenCategory, forKey: "choosenCategory")
        
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
        print(choosenCategory)
    }

}
