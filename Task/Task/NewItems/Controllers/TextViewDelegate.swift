//
//  TextViewDelegate.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
extension NewViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        textView.text = ""
        textView.textColor = .black
        return true
    }

      
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func setUpDate(){

            let choosenDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM YY HH:mm"
            let dateString = dateFormatter.string(from: choosenDate)
            dateLabel.text = dateString

    }


}
