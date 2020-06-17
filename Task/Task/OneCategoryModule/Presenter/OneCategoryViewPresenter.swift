//
//  OneCategoryPresenter.swift
//  Task
//
//  Created by Азизбек on 17.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryViewPresenter {

    let view: OneCategoryViewController
    let needToUpdateNotificationID = "ru.azizbek.needToUpdateTableNotificationID"
    var newDictionary = ["Late": [Task](), "In progress": [Task](), "Done": [Task]()]
    var taskSectionsArray = [TaskSections]()
    let headerViewMaxHeight: CGFloat = 290
    let height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

    init(view: OneCategoryViewController) {
        self.view = view
      NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(needToUpdateNotificationID), object: nil)
    }
    @objc func updateTable() {
        getTasks()
        view.tableView.reloadData()
        print("updateTable")
    }
    func getTasks() {
           print("allTasks")
           let timestamp = Date().timeIntervalSince1970

        if view.titleOutlet.text == "All"{
               CoreDataService.shared.fetchTasks {[weak self] (allTasks) in
                self?.taskSectionsArray.removeAll()
                   for (key, _) in self!.newDictionary {
                       self?.newDictionary[key] = [Task]()
                   }
                self?.view.tastsCountOutlet.text = "\(allTasks.count) tasks"
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
            CoreDataService.shared.fetchTasks(category: view.titleOutlet.text!) {[weak self] (categoryTask) in
                   self?.taskSectionsArray.removeAll()
                   for (key, _) in self!.newDictionary {
                       self?.newDictionary[key] = [Task]()
                   }
                self?.view.tastsCountOutlet.text = "\(categoryTask.count) tasks"
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
