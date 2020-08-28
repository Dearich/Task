//
//  ModuleBuilder.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit
protocol Builder {
    static func createMain() -> UIViewController
    static func creatCategoryScreen() -> UIViewController
    static func createNewTaskScreen() -> NewTaskViewController
    static func createOneCategoryScreen() -> OneCategoryViewController
}

class ModuleBuilder: Builder {

    static func createNewTaskScreen() -> NewTaskViewController {
        let view = NewTaskViewController()
        let newTaskPresenter = NewTaskPresenter(view: view)
        view.newTaskPresenter = newTaskPresenter
        return view
    }

    static func creatCategoryScreen() -> UIViewController {
        let view = CategoryViewController()
        let categoryPresentrer = CategoryPresenter(view: view)
        view.presenter = categoryPresentrer
        return view
    }

    static func createMain() -> UIViewController {
        let view = MainViewController()
        let mainPresenter = MainPresenter(view: view)
        view.mainPresenter = mainPresenter
        return view
    }

    static func createOneCategoryScreen() -> OneCategoryViewController {
        let stroyboard = UIStoryboard(name: "OneCategoty", bundle: nil)
        guard let viewController = stroyboard.instantiateViewController(identifier: "OneCategoryViewController") as? OneCategoryViewController else {return OneCategoryViewController()}
        let presenter = OneCategoryViewPresenter(view: viewController)
        viewController.oneCategoryPresenter = presenter

        return viewController
    }
}
