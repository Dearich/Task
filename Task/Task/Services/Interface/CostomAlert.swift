//
//  CostomAlert.swift
//  Task
//
//  Created by Азизбек on 15.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
class CostomAlertController: UIAlertController {

    func setup(title: String, discription: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: discription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true)

       }
}
