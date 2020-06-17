//
//  MainViewController.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var mainPresenter: MainViewPresenterProtocol!
    let activityIndicatior = UIActivityIndicatorView(style: .large)

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            navigationController?.navigationBar.isHidden = true
            view.setUpActivityIndicator(view: view, activityIndicator: activityIndicatior)
            guard let navigationController = self.navigationController else { return }
            mainPresenter.goToNextScreen(navigationController: navigationController )
            activityIndicatior.stopAnimating()
            activityIndicatior.isHidden = true
        }

    }

    extension MainViewController: MainViewProtocol {
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
