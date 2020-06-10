//
//  OneCategoryTableViewCell.swift
//  Task
//
//  Created by Азизбек on 10.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class OneCategoryTableViewCell: UITableViewCell {
    
    var task:Task!
    @IBOutlet weak var discriptionTitle: UILabel!
    @IBOutlet weak var dateSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        discriptionTitle.text = task.discription
        dateSubTitle.text = task.date
    }

    @IBAction func doneAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }

}
