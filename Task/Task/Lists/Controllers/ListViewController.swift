//
//  ListViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "cell"

class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var dataSource = ListsCollectionViewController()
    var listItems = [CategoryList]()
    @objc dynamic var listNames: [String]?
    var observer: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ListsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        dataSource.listsCollectionViewControllerDelegate = self
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        CoreDataService.shared.fetchLists {[weak self] (category) in
                    self?.dataSource.listItems = category
                    self?.listItems = category
            }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        collectionView.reloadData()
    }

    @objc func menu() {
        print("menu")
    }

    @IBAction func addButtonAction(_ sender: UIButton) {
        let stroyboard = UIStoryboard(name: "NewItemStoryboard", bundle: nil)
        guard let viewController = stroyboard.instantiateViewController(identifier: "NewViewController") as? NewViewController else { return }
        navigationController?.show(viewController, sender: sender)
    }
}

extension ListViewController {

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

}

extension ListViewController: ListsCollectionViewControllerDelegate {
    func didSelectItem(dataSource: ListsCollectionViewController, indexPath: Int) {

        let stroyboard = UIStoryboard(name: "OneCategoty", bundle: nil)
        guard let viewController = stroyboard.instantiateViewController(identifier: "OneCategoryViewController") as? OneCategoryViewController else { return }
        guard let headerName = listItems[indexPath].name else { return }
        guard let imageName = listItems[indexPath].imageName else { return }
        viewController.headerString = headerName
        viewController.imageString = imageName
        navigationController?.show(viewController, sender: self)
    }
}
