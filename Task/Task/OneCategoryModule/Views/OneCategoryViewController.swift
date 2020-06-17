//
//  NewItemViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryViewController: UIViewController {

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var tastsCountOutlet: UILabel!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    var headerString: String = ""
    var imageString: String = ""
    var oneCategoryPresenter: OneCategoryViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeaderView()
        navConfig()
        tableView.layer.cornerRadius = 20
        oneCategoryPresenter.getTasks()
    }

    @objc func back() {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
        print("back")
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }

    @IBAction func addTapped(_ sender: UIButton) {
        let viewController = ModuleBuilder.createNewTaskScreen()
        print(headerString)
        viewController.newTaskPresenter.categoryString = headerString
        navigationController?.show(viewController, sender: sender)
    }

}

extension OneCategoryViewController {

    func setUpHeaderView() {
        imageOutlet.image = UIImage(named: imageString)
        imageOutlet.backgroundColor = .white
        imageOutlet.layer.masksToBounds = true
        imageOutlet.layer.cornerRadius = 30

        titleOutlet.text = headerString
        titleOutlet.textColor = .white
    }

    func navConfig() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target:
            self, action: #selector(back))
    }
}
