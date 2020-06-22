//
//  ViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let activityIndicatior = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        view.setUpActivityIndicator(view: view, activityIndicator: activityIndicatior)
        if UserDefaults.standard.bool(forKey: "isStarted") {
            print("already started")
        } else {
            print("isStarted first ")
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

        activityIndicatior.stopAnimating()
        activityIndicatior.isHidden = true
        let storyboard = UIStoryboard(name: "ListStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ListViewController")
        guard let navigationController = self.navigationController else { return }
        navigationController.show(viewController, sender: self)

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
