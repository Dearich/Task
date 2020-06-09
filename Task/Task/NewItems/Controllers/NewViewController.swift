//
//  NewViewController.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {



    @IBOutlet weak var textViewOutlet: UITextView!

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!


    @IBOutlet weak var hightLabel: NSLayoutConstraint!
    @IBOutlet weak var hightTextView: NSLayoutConstraint!
    @IBOutlet weak var spaceLabelTextView: NSLayoutConstraint!
    @IBOutlet weak var spaceLabelView: NSLayoutConstraint!

    @IBOutlet weak var dateLabel: UILabel!
    var dateString: String?
    

    var shapeLayer: CAShapeLayer!{
        didSet {
            shapeLayer.lineWidth = 2
            shapeLayer.lineCap =  CAShapeLayerLineCap(rawValue: "round")
            shapeLayer.fillColor = nil

            shapeLayer.strokeEnd = 1
            shapeLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor


        }
    }
    
    override func viewDidLayoutSubviews() {
       configShapeLAyer(shapeLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeLayer = CAShapeLayer()
        textViewOutlet.delegate = self
        textViewOutlet.becomeFirstResponder()
        subView.layer.addSublayer(shapeLayer)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target:
        self, action: #selector(close))
       navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        costomtextView()
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(handle(keyboardShowNotification:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
    }
    
    @objc
    private func handle(keyboardShowNotification notification: Notification) {
        // 1
        print("Keyboard show notification")
        
        // 2
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            UIView.animate(withDuration: 0.1) {
                self.bottomConstraint.constant = keyboardRectangle.height
            }
           
        }
    }

    @objc func close() {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "New Task"
        navigationItem.hidesBackButton = true
        setUpDate()
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func costomtextView(){
        textViewOutlet.backgroundColor = .clear
        textViewOutlet.layer.borderWidth = 0
    }
    
    func configShapeLAyer(_ shapeLayer: CAShapeLayer) {
           //задаем отображение и указывем направление отрисовки фигуры
                   shapeLayer.frame = textViewOutlet.bounds
                  let path = UIBezierPath()
        path.move(to: CGPoint(x:textViewOutlet.frame.minX , y:textViewOutlet.frame.maxY ))    //начальная точка отрисовк
        path.addLine(to: CGPoint(x:textViewOutlet.frame.maxX , y: textViewOutlet.frame.maxY )) // конечная точка отрисовки
                  shapeLayer.path = path.cgPath //добавляем путь отрисоки
       }
    
    @IBAction func dataAction(_ sender: UIButton) {
        
        let myViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        self.addChild(myViewController)
               myViewController.view.frame = self.view.frame
               self.view.addSubview(myViewController.view)
               
               myViewController.didMove(toParent: self)
    }
    
    
}
