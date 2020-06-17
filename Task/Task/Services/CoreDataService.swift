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

     lazy var taskPersistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "Task")
         container.loadPersistentStores(completionHandler: { (_, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()

     // MARK: - Core Data Saving support

     func saveContext () {
         let context = taskPersistentContainer.viewContext
         if context.hasChanges {
             do {
                 try context.save()
             } catch {
                 // Replace this implementation with code to handle the error appropriately.
                 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 let nserror = error as NSError
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         }
     }

    func saveCategory(lists: OneCategory) {
       let managedContext = taskPersistentContainer.viewContext
        let category = CategoryList(context: managedContext)
        category.name = lists.name
        category.imageName = lists.image

        saveContext()
    }

    func fetchLists(complition: @escaping (_ lists: [CategoryList]) -> Void) {
        let managedContext = taskPersistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CategoryList>(entityName: "CategoryList")
        do {
            let categorys = try managedContext.fetch(fetchRequest)
            complition(categorys)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func saveTask(category: String, discription: String, date: Double) {
        let managedContext = taskPersistentContainer.viewContext
        let task = Task(context: managedContext)
        task.date = date
        task.discription = discription
        task.done = false

        fetchLists { (allCategory) in
            for oneCategory in allCategory where oneCategory.name == category {
                oneCategory.addToTasks(task)
            }
        }

        saveContext()
    }

    func fetchTasks(category: String? = nil, complition:@escaping (_ tasks: [Task]) -> Void) {
        let managedContext = taskPersistentContainer.viewContext
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

        } catch let error {
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
                } catch  let error {
                    print(error.localizedDescription)
                }

            }
        }
    }
    func deleteTask(task: Task) {
        let managedContext = taskPersistentContainer.viewContext
        managedContext.delete(task)

        do {
            try managedContext.save()
            print("Удачное удаление")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
