//
//  CategoryViewController.swift
//  Task
//
//  Created by Азизбек on 10.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryViewControllerDelegate: class {
    func getCategory(category: String)
}

class CategoryViewController: UIViewController, UIPickerViewDelegate {
    let setCategoryNotificationID = "ru.azizbek.setCategoryNotificationID"

    var arrayOfNames = [String]()
    var choosenCategory = "Work"
    weak var categoryViewControllerDelegate: CategoryViewControllerDelegate?

    @IBOutlet weak var pickerOutlet: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataService.shared.fetchLists {[weak self] (lists) in
            for list in lists {
                if list.name == "All"{
                    continue
                } else {
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

        categoryViewControllerDelegate?.getCategory(category: choosenCategory)

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
