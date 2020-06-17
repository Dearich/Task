//
//  PopUpViewController.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

protocol PopUpViewControllerDelegate: class {
    func getDate(timestamp: Double)
}

class PopUpViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var popUpViewControllerDelegate: PopUpViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        print("PopUpViewController")

    }
    @IBAction func done(_ sender: UIButton) {
        let choosenDate = datePicker.date
        let timestamp = choosenDate.timeIntervalSince1970
        popUpViewControllerDelegate?.getDate(timestamp: timestamp)
        view.removeFromSuperview()
    }

}
