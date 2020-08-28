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
    var activityIndicator: UIActivityIndicatorView { get }
    var mainView: UIView { get }
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
    private func saveCategoroies(complition: @escaping ((Bool) -> Void)) {
        view.mainView.setUpActivityIndicator(view: view.mainView, activityIndicator: view.activityIndicator)
        if UserDefaults.standard.bool(forKey: "isStarted") {
            print("already started")
            complition(true)
            view.checkFirstStart(bool: false)
        } else {
            print("isStarted first ")
            view.checkFirstStart(bool: true)
            UserDefaults.standard.set(true, forKey: "isStarted")
            JSONService.shared.parse { (listsOfItems, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    complition(false)
                } else {
                    guard let dictionaryList = listsOfItems else { return }

                        for list in dictionaryList.lists {
                            CoreDataService.shared.saveCategory(lists: list)
                    }
                    complition(true)
                }
            }
        }
    }

    func goToNextScreen(navigationController: UINavigationController) {
        saveCategoroies { (bool) in
            print(bool)
            if bool {
                DispatchQueue.main.async {
                    self.view.activityIndicator.stopAnimating()
                    self.view.activityIndicator.isHidden = true
                    let categoryViewController = ModuleBuilder.creatCategoryScreen()
                    navigationController.show(categoryViewController, sender: self)
                }
            }
        }
    }

}
