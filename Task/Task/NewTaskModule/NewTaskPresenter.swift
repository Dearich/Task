//
//  NewTaskPresenter.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

protocol NewTaskViewProtocol: class {
    func getCategoryString(categoryString: String)
    func getDateString(dateString: String)
    var taskText: String { get }
    var taskbottomConstraint: NSLayoutConstraint { get }
}

protocol NewTaskViewPresenterProtocol {
    func dataAction(viewController: UIViewController)
    func categotyAction(viewController: UIViewController)
    func save(navigationController: UINavigationController, viewController: UIViewController)
    var  dateString: String { get set }
    var categoryString: String { get set }
    init(view: NewTaskViewProtocol)
}
//let needToUpdateNotificationID = "ru.azizbek.needToUpdateTableNotificationID"
//
//       NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

class NewTaskPresenter: NewTaskViewPresenterProtocol {

    private let needToUpdateNotificationID = "ru.azizbek.needToUpdateTableNotificationID"
    var dateString: String = {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        let strDate = dateFormatter.string(from: currentDate)
        return strDate
    }()
    var timestamp: Double = 0.0
    let view: NewTaskViewProtocol!
    var categoryString: String = "Category"

    required init(view: NewTaskViewProtocol) {
        self.view = view
        categoryViewController.categoryViewControllerDelegate = self
        popUpViewController.popUpViewControllerDelegate = self
         NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func handle(keyboardShowNotification notification: Notification) {

           print("Keyboard show notification")

           if let userInfo = notification.userInfo,

               let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
               print(keyboardRectangle.height)
               UIView.animate(withDuration: 0.1) {
                self.view.taskbottomConstraint.constant = keyboardRectangle.height
                print(self.view.taskbottomConstraint.constant)
               }
           }
       }

    let popUpViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
    let categoryViewController = CategoryPopUpController(nibName: "CategoryPopUpController", bundle: nil)
    let costomAlert = CostomAlertController()

    func dataAction(viewController: UIViewController) {

        viewController.addChild(popUpViewController)
        popUpViewController.view.frame = viewController.view.frame
        viewController.view.addSubview(popUpViewController.view)
        print("dataAction")
        popUpViewController.didMove(toParent: viewController)
    }
    func categotyAction(viewController: UIViewController) {
        print("categotyAction")
        viewController.addChild(categoryViewController)
        categoryViewController.view.frame = viewController.view.frame
        viewController.view.addSubview(categoryViewController.view)
        categoryViewController.didMove(toParent: viewController)
    }

    func save(navigationController: UINavigationController, viewController: UIViewController) {
        if timestamp == 0.0 {
            timestamp = Date().timeIntervalSince1970
        }
        print("presenter save:\(timestamp)")
        guard view.taskText != "" else { costomAlert.setup(title: "Empty Task", discription: "", viewController: viewController); return }
        guard categoryString != "Category" else { costomAlert.setup(title: "Choose Category", discription: "", viewController: viewController); return }
        CoreDataService.shared.saveTask(category: categoryString, discription: view.taskText, date: timestamp)
        navigationController.popViewController(animated: true)
        updateTable()
    }
    private func updateTable() {
        NotificationCenter.default.post(name: NSNotification.Name(needToUpdateNotificationID), object: self)
    }

}

extension NewTaskPresenter: CategoryViewControllerDelegate, PopUpViewControllerDelegate {

    func getDate(timestamp: Double) {

        self.timestamp = timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = NSLocale.current
        dateFormater.dateFormat = "dd MMMM HH:mm"
        let strDate = dateFormater.string(from: date)
        view.getDateString(dateString: strDate)
    }

    func getCategory(category: String) {
        view.getCategoryString(categoryString: category)
    }

}

//@objc private func handle(keyboardShowNotification notification: Notification) {
//
//    print("Keyboard show notification")
//
//    if let userInfo = notification.userInfo,
//
//        let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//        print(keyboardRectangle.height)
//        UIView.animate(withDuration: 0.1) {
//            self.bottomConstraint.constant = keyboardRectangle.height
//        }
//    }
//}

/*

 @objc func close() {
 }

 @IBAction func createAction(_ sender: UIButton) {
     guard !textViewOutlet.text.isEmpty else { costomAlert.setup(title: "Empty Task", discription: ""); return }
     guard categoryLabel.text != "Category" else { costomAlert.setup(title: "Choose Category", discription: ""); return }

     if timestamp == 0.0 {
         let date = Date().timeIntervalSince1970
         timestamp = date
     }
      guard let timestamp = timestamp else { return }

 }*/
