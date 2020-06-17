//
//  MainPresenter.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewProtocol:class {
    func checkFirstStart(bool: Bool)
}
protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol )
    func goToNextScreen(navigationController: UINavigationController)
}

class MainPresenter: MainViewPresenterProtocol {

    let view: MainViewProtocol
    required init(view: MainViewProtocol) {
        self.view = view
    }

     private func saveCategoroies() {
        if UserDefaults.standard.bool(forKey: "isStarted") {
            print("already started")
            view.checkFirstStart(bool: false)
        } else {
            print("isStarted first ")
            view.checkFirstStart(bool: true)
            UserDefaults.standard.set(true, forKey: "isStarted")
            JSONService.shared.parse { (listsOfItems, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    guard let dictionaryList = listsOfItems else { return }
                    for list in dictionaryList.lists {
                        DispatchQueue.main.async {
                            CoreDataService.shared.saveCategory(lists: list)
                        }
                    }
                }
            }
        }
    }

    func goToNextScreen(navigationController: UINavigationController) {
        saveCategoroies()
        let categoryViewController = ModuleBuilder.creatCategoryScreen()
        navigationController.show(categoryViewController, sender: self)

    }

}
