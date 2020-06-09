//
//  NewItemViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryViewController: UIViewController {

    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    let headerViewMaxHeight: CGFloat = 314
    let height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

    var headerString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(headerString)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target:
            self, action: #selector(back))
        navigationController?.navigationBar.tintColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 20
    }
    
    @objc func back() {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
        print("back")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear

    }

    @

}
