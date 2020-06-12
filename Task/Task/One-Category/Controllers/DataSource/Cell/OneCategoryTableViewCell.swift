//
//  OneCategoryTableViewCell.swift
//  Task
//
//  Created by Азизбек on 10.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryTableViewCell: UITableViewCell {

    let needToUpdateNotificationID = "ru.azizbek.needToUpdateTableNotificationID"

    var task: Task!
    @IBOutlet weak var discriptionTitle: UILabel!
    @IBOutlet weak var dateSubTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func updateTable() {
        NotificationCenter.default.post(name: NSNotification.Name(needToUpdateNotificationID), object: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let timestamp = task.date
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = NSLocale.current
        dateFormater.dateFormat = "dd MMMM HH:mm"
        let strDate = dateFormater.string(from: date)
        dateSubTitle.text = strDate
        discriptionTitle.text = task.discription

    }

    @IBAction func doneAction(_ sender: UIButton) {
        if sender.isSelected {
            print("Not Done")

            CoreDataService.shared.updateStatus(task: task, value: false)
             sender.isSelected = false
             updateTable()
        } else {

            print("Done")

            CoreDataService.shared.updateStatus(task: task, value: true)
            sender.isSelected = true
             updateTable()

        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        button.imageView?.image = nil
        discriptionTitle.text = nil
    }

}
