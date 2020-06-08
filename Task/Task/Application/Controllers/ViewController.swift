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
        setUpActivityIndicator()
        delay(2) {
            self.activityIndicatior.stopAnimating()
            self.activityIndicatior.isHidden = true
            let storyboard = UIStoryboard(name: "ListStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ListViewController")
            guard let navigationController = self.navigationController else { return }
            navigationController.show(vc, sender: self)
            
        }
    }
    
    func delay (_ delay: Int, closure: @ escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
    func setUpActivityIndicator() {
        activityIndicatior.color = .white
        view.addSubview(activityIndicatior)
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatior.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatior.startAnimating()
    }

}

