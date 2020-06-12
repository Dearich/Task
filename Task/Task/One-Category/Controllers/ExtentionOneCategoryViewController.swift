//
//  ExtentionNewItemController.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

struct Objects {

    var sectionName: String!
    var sectionObjects: [Task]!
}

extension OneCategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return objectArray.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 70))
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let title = UILabel()
        title.text = objectArray[section].sectionName
        title.textColor = .lightGray
        title.textAlignment = .left
        headerView.addSubview(title)
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        title.addConstraintsWithFormat(format: "H:|-20-[v0]-10-|", views: title)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 15))
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OneCategoryTableViewCell else {return UITableViewCell()}
        let oneTask = objectArray[indexPath.section].sectionObjects[indexPath.row]
        cell.task = oneTask

        if oneTask.done {
            cell.button.imageView?.image = UIImage(named: "check")
            cell.button.isSelected = true
            cell.discriptionTitle.textColor = .systemBlue
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: oneTask.description)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            cell.discriptionTitle.attributedText = attributeString
        } else {
            cell.button.imageView?.image = UIImage(named: "uncheck")
            cell.button.isSelected = false
            cell.discriptionTitle.textColor = .black
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: oneTask.description)

            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: attributeString.length))
            cell.discriptionTitle.attributedText = attributeString
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Update") { (_, _, _) in

        }
        contextItem.backgroundColor = #colorLiteral(red: 0.346395731, green: 0.5247719884, blue: 1, alpha: 1)
        let swipeAction = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeAction

    }

      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {[weak self]  (_, _, _) in
            guard let correntTask = self?.objectArray[indexPath.section].sectionObjects[indexPath.row] else { return }
             CoreDataService.shared.deleteTask(task: correntTask)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self?.getTasks()
         }
         let swipeAction = UISwipeActionsConfiguration(actions: [contextItem])

         return swipeAction
     }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let headerViewMinHeight: CGFloat =  height + 70

        let offsetY: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = headerViewHeightConstraint.constant - offsetY
        if newHeaderViewHeight > headerViewMaxHeight {
            UIView.animate(withDuration: 0.4) {
                          self.imageOutlet.alpha = 1.0
                          self.titleOutlet.alpha = 1.0
                          self.tastsCountOutlet.alpha = 1.0
                      }
            navigationItem.title = ""
            headerViewHeightConstraint.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            headerViewHeightConstraint.constant = headerViewMinHeight
            navigationItem.title = "\(headerString)"

        } else {
            headerViewHeightConstraint.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0
        }

        if headerViewHeightConstraint.constant > 275 {
            setAnimation(with: 1.0, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 250 {
            setAnimation(with: 0.7, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 225 {
            setAnimation(with: 0.6, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 200 {
            setAnimation(with: 0.5, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 175 {
            setAnimation(with: 0.4, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 150 {
            setAnimation(with: 0.3, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 125 {
            setAnimation(with: 0.2, duration: 0.1)
        } else if headerViewHeightConstraint.constant  > 100 {
            setAnimation(with: 0.0, duration: 0.1)
        }
    }
    private func setAnimation(with alpha: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.imageOutlet.alpha = alpha
            self.titleOutlet.alpha = alpha
            self.tastsCountOutlet.alpha = alpha
        }
    }

}
