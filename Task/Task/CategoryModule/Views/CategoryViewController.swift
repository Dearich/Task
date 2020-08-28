//
//  CategoryViewController.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, CategoryViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!

        var presenter: CategoryViewPresenterProtocol!
        var categoryNavigationController: UINavigationController?
        private let reuseIdentifier = "CollectionCell"

        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.register(ListsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            presenter.showCategories()
            setUpCleanNavBar()

        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            categoryNavigationController = self.navigationController
            setUpNavigationBar()
            collectionView.reloadData()
        }

        @objc func menu() {
            print("menu")
        }

        @IBAction func addButtonAction(_ sender: UIButton) {
            guard let navigationController = navigationController else { return }
            presenter.addNewTask(sender, navigationController: navigationController)
        }
    }

extension CategoryViewController {

        func setUpCategory(dataSource: CategoryCollectionDataSource) {
            collectionView.dataSource = dataSource
            collectionView.delegate = dataSource
        }
}

extension CategoryViewController {

    func setUpNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Lists"
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-4"), landscapeImagePhone: UIImage(named: "menu-4"), style: .done, target: self, action: #selector(menu))
        navigationController.navigationBar.tintColor = UIColor.black
    }

    func setUpCleanNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}
