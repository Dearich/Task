//
//  NewItemViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryViewController: UIViewController {

    let needToUpdateNotificationID = "ru.azizbek.needToUpdateTableNotificationID"

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var tastsCountOutlet: UILabel!

    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    let headerViewMaxHeight: CGFloat = 290
    let height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

    var headerString: String = ""
    var imageString: String = ""
    var newDictionary = ["Late": [Task](), "In progress": [Task](), "Done": [Task]()]
    var taskSectionsArray = [TaskSections]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHeaderView()
        navConfig()
        getTasks()
        tableView.layer.cornerRadius = 20

        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(needToUpdateNotificationID), object: nil)
    }

    @objc func updateTable() {
        getTasks()
        self.tableView.reloadData()
        print("updateTable")
    }

    @objc func back() {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
        print("back")
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }

    @IBAction func addTapped(_ sender: UIButton) {

        let stroyboard = UIStoryboard(name: "NewItemStoryboard", bundle: nil)
        guard let viewController = stroyboard.instantiateViewController(identifier: "NewViewController") as? NewViewController else { return }
        viewController.categoryString = headerString
        navigationController?.show(viewController, sender: sender)
    }

    func getTasks() {
        print("allTasks")
        let timestamp = Date().timeIntervalSince1970

        if titleOutlet.text == "All"{
            CoreDataService.shared.fetchTasks {[weak self] (allTasks) in
                self?.taskSectionsArray.removeAll()
                for (key, _) in self!.newDictionary {
                    self?.newDictionary[key] = [Task]()
                }
                self?.tastsCountOutlet.text = "\(allTasks.count) tasks"
                for task in allTasks {
                    if  task.date < timestamp && !task.done {
                        self?.newDictionary["Late"]?.append(task)
                        print("++++++++++++++++++++++++++++++++++++++++")
                        print("\(task.date) < \(timestamp)")
                         print("++++++++++++++++++++++++++++++++++++++++")
                    } else if task.done {
                        self?.newDictionary["Done"]?.append(task)
                    } else {
                        self?.newDictionary["In progress"]?.append(task)
                    }
                }
                let sortedDic = self?.newDictionary.sorted(by: { $0.0 > $1.0 })
                    for (key, value) in sortedDic! {
                        self?.taskSectionsArray.append(TaskSections(sectionName: key, sectionObjects: value))
                    }

            }
        } else {
            CoreDataService.shared.fetchTasks(category: titleOutlet.text!) {[weak self] (categoryTask) in
                self?.taskSectionsArray.removeAll()
                for (key, _) in self!.newDictionary {
                    self?.newDictionary[key] = [Task]()
                }
                self?.tastsCountOutlet.text = "\(categoryTask.count) tasks"
                for task in categoryTask {
                    if task.date < timestamp && !task.done {
                        self?.newDictionary["Late"]?.append(task)
                    } else if task.done {

                        self?.newDictionary["Done"]?.append(task)
                    } else {
                        self?.newDictionary["In progress"]?.append(task)
                    }
                }
                let sortedDic = self?.newDictionary.sorted(by: { $0.0 > $1.0 })
                for (key, value) in sortedDic! {
                    self?.taskSectionsArray.append(TaskSections(sectionName: key, sectionObjects: value))
                }
            }
        }
    }
}

extension OneCategoryViewController {
    
    func setUpHeaderView() {
        imageOutlet.image = UIImage(named: imageString)
        imageOutlet.backgroundColor = .white
        imageOutlet.layer.masksToBounds = true
        imageOutlet.layer.cornerRadius = 30

        titleOutlet.text = headerString
        titleOutlet.textColor = .white
    }
    
    func navConfig(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target:
            self, action: #selector(back))
    }
}
