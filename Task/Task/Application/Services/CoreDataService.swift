//
//  CoreDataService.swift
//  Task
//
//  Created by Азизбек on 10.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {

   static let shared = CoreDataService()

    func saveCategory(lists: ListsItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let category = CategoryList(context: managedContext)
        category.name = lists.name
        category.imageName = lists.image

        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchLists(complition: @escaping (_ _lists: [CategoryList]) -> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CategoryList>(entityName: "CategoryList")
        do {
            let categorys = try managedContext.fetch(fetchRequest)
            complition(categorys)
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveTask(category: String, discription: String, date: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let task = Task(context: managedContext)
        task.date = date
        task.discription = discription
        task.done = false

        fetchLists { (allCategory) in
            for oneCategory in allCategory where oneCategory.name == category {
                oneCategory.addToTasks(task)
            }
        }

        do {
            try managedContext.save()
            print("Успешное создание таска")
            print(task)
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchTasks(category: String? = nil, complition:@escaping (_ tasks: [Task]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        let sortDiscriptor = NSSortDescriptor(key: #keyPath(Task.date), ascending: false)
        let sortDiscriptor2 = NSSortDescriptor(key: #keyPath(Task.category), ascending: true)
        fetchRequest.sortDescriptors = [sortDiscriptor, sortDiscriptor2]
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            if category == nil {
                complition(tasks)

            } else {
                var taskFromSomeCategory = [Task]()
                for task in tasks where task.category?.name == category {
                    taskFromSomeCategory.append(task)
                }
                complition(taskFromSomeCategory)
            }

        } catch {
            print(error.localizedDescription)
        }
    }

    func updateStatus(task: Task, value: Bool) {
        fetchTasks { (allTask) in
            for oneTask in allTask where oneTask === task {
                oneTask.setValue(value, forKey: "done")

                do {
                    try oneTask.managedObjectContext?.save()
                    print("Удачное изменение")
                } catch {
                    print(error.localizedDescription)
                }

            }
        }
    }
    func deleteTask(task: Task) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        managedContext.delete(task)

        do {
            try managedContext.save()
            print("Удачное удаление")
        } catch {
            print(error.localizedDescription)
        }
    }
}
