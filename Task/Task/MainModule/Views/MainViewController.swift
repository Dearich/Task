//
//  MainViewController.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewProtocol {

    var mainView: UIView = UIView()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    var mainPresenter: MainViewPresenterProtocol!

        override func viewDidLoad() {
            super.viewDidLoad()
            mainView = self.view
            navigationController?.navigationBar.isHidden = true
            guard let navigationController = self.navigationController else { return }
            mainPresenter.goToNextScreen(navigationController: navigationController )
        }

    }

    extension MainViewController {
        func checkFirstStart(bool: Bool) {
            print(bool)
        }
    }

    extension UIView {
        func setUpActivityIndicator(view: UIView, activityIndicator: UIActivityIndicatorView) {
            activityIndicator.color = .white
            view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            activityIndicator.startAnimating()
        }

        func delay (_ delay: Int, closure: @ escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                closure()
            }
        }
    }
