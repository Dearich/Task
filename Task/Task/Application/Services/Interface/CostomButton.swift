//
//  CostomButton.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

//@IBDesignable
class Button: UIButton {
    
//    private var size = CGSize()
//
//    @IBInspectable var cornerRadiusButton: CGFloat = 0 {
//        didSet {
//            size = CGSize(width: cornerRadiusButton, height: cornerRadiusButton)
//        }
//    }
    
     var color: UIColor = #colorLiteral(red: 0.346395731, green: 0.5247719884, blue: 1, alpha: 1)

    var path: UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        color.setFill()
        path?.fill() //заполнение фигуры зеленым цветом
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let path = path {
            return path.contains(point)
        }
        return false
    }
    

}

