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
    var imageString:String = ""
    var newDictionary = ["Late": [Task](), "In progress": [Task](), "Done": [Task]()]
    var objectArray = [Objects]()
    
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(needToUpdateNotificationID), object: nil)
    }
    
    @objc func updateTable(){
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
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        
        let stroyboard = UIStoryboard(name:"NewItemStoryboard" , bundle: nil)
        let vc = stroyboard.instantiateViewController(identifier: "NewViewController") as! NewViewController
        vc.categoryString = headerString
        navigationController?.show(vc, sender: sender)
    }
    
    func getTasks() {
        print("allTasks")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        let currentDate = Date()
        let currentTimeStamp = currentDate.timeIntervalSince1970
        
        
        if titleOutlet.text == "All"{
            CoreDataService.shared.fetchTasks {[weak self] (allTasks) in
                self?.objectArray.removeAll()
                for (key,_) in self!.newDictionary{
                    self?.newDictionary[key] = [Task]()
                }
                self?.tastsCountOutlet.text = "\(allTasks.count) tasks"
                for task in allTasks {
                    let dateObj = dateFormatter.date(from: task.date!)
                    let objTimeStamp = dateObj?.timeIntervalSince1970
                    if let taskTimeStamp = objTimeStamp, taskTimeStamp < currentTimeStamp && !task.done{
                        self?.newDictionary["Late"]?.append(task)
                        print("++++++++++++++++++++++++++++++++++++++++")
                        print("\(taskTimeStamp) < \(currentTimeStamp)")
                         print("++++++++++++++++++++++++++++++++++++++++")
                    } else if task.done{
                        self?.newDictionary["Done"]?.append(task)
                    } else {
                        self?.newDictionary["In progress"]?.append(task)
                    }
                }
                let sortedDic = self?.newDictionary.sorted(by: { $0.0 > $1.0 })
                    for (key, value) in sortedDic! {
                        self?.objectArray.append(Objects(sectionName: key, sectionObjects: value))
                    }
                
            }
        } else {
            CoreDataService.shared.fetchTasks(category: titleOutlet.text!) {[weak self] (categoryTask) in
                self?.objectArray.removeAll()
                for (key,_) in self!.newDictionary{
                    self?.newDictionary[key] = [Task]()
                }
                self?.tastsCountOutlet.text = "\(categoryTask.count) tasks"
                for task in categoryTask {
                    let dateObj = dateFormatter.date(from: task.date!)
                    if let taskDate = dateObj, taskDate < Date(){
                        self?.newDictionary["Late"]?.append(task)
                    } else if task.done{
                        
                        self?.newDictionary["Done"]?.append(task)
                    } else {
                        self?.newDictionary["In progress"]?.append(task)
                    }
                }
                let sortedDic = self?.newDictionary.sorted(by: { $0.0 > $1.0 })
                for (key, value) in sortedDic! {
                    self?.objectArray.append(Objects(sectionName: key, sectionObjects: value))
                }
            }
        }
    }
}
