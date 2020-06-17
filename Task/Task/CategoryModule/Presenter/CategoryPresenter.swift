//
//  CategoryPresenter.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryViewProtocol: class {
    func setUpCategory(dataSource: CategoryCollectionDataSource)
    var categoryNavigationController: UINavigationController? { get }
}

protocol CategoryViewPresenterProtocol {
    init(view:CategoryViewProtocol )
    func showCategories()
    func addNewTask(_ sender: UIButton, navigationController: UINavigationController)
}

class CategoryPresenter: CategoryViewPresenterProtocol {

    let view: CategoryViewProtocol

    private let dataSource = CategoryCollectionDataSource()
    private var categories = [CategoryList]()

    required init(view: CategoryViewProtocol) {
        self.view = view
    }

    func showCategories() {
        CoreDataService.shared.fetchLists {[weak self] (categories) in
            self?.dataSource.listItems = categories
            self?.categories = categories
            self?.view.setUpCategory(dataSource: self!.dataSource)
            self?.dataSource.categoryCollectionDataSourceDelegate = self
        }
    }

    func addNewTask(_ sender: UIButton, navigationController: UINavigationController) {
        let newTaskViewController = ModuleBuilder.createNewTaskScreen()
        navigationController.show(newTaskViewController, sender: sender)
    }
}

extension CategoryPresenter: CategoryCollectionDataSourceDelegate {
      func didSelectItem(dataSource: CategoryCollectionDataSource, indexPath: Int) {

        let viewController = ModuleBuilder.createOneCategoryScreen()
            guard let headerName = categories[indexPath].name else { return }
            guard let imageName = categories[indexPath].imageName else { return }
            viewController.headerString = headerName
            viewController.imageString = imageName
        guard let navigationController = view.categoryNavigationController else { return }
        navigationController.show(viewController, sender: self)
            }
}
