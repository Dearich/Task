//
//  NewItemViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryViewController: UIViewController {
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var tastsCountOutlet: UILabel!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    let headerViewMaxHeight: CGFloat = 314
    let height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

    var headerString: String = ""
    var imageString:String = ""
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOutlet.image = UIImage(named: imageString)
        imageOutlet.backgroundColor = .white
        imageOutlet.layer.masksToBounds = true
        imageOutlet.layer.cornerRadius = 30
        
        titleOutlet.text = headerString
        titleOutlet.textColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target:
            self, action: #selector(back))
        getTasks()
        tableView.layer.cornerRadius = 20
    }
    
    @objc func back() {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
        print("back")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.tintColor = UIColor.white
        tableView.reloadData()

    }

    @IBAction func addTapped(_ sender: UIButton) {
        
        let stroyboard = UIStoryboard(name:"NewItemStoryboard" , bundle: nil)
        let vc = stroyboard.instantiateViewController(identifier: "NewViewController") as! NewViewController
        navigationController?.show(vc, sender: sender)
    }
    
    func getTasks() {
        print("allTasks")
        if titleOutlet.text == "All"{
            CoreDataService.shared.fetchTasks {[weak self] (allTasks) in
                self?.tasks = allTasks
//                print("allTasks")
            }
        } else {
            CoreDataService.shared.fetchTasks(category: titleOutlet.text!) {[weak self] (categoryTask) in
                self?.tasks = categoryTask
            }
        }
        
    }

}
