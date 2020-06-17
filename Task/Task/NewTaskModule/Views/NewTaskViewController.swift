//
//  NewTaskViewController.swift
//  Task
//
//  Created by Азизбек on 16.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController, NewTaskViewProtocol {
    

    @IBOutlet weak var textViewOutlet: UITextView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hightLabel: NSLayoutConstraint!
    @IBOutlet weak var hightTextView: NSLayoutConstraint!
    @IBOutlet weak var spaceLabelTextView: NSLayoutConstraint!
    @IBOutlet weak var spaceLabelView: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var newTaskPresenter: NewTaskViewPresenterProtocol!
    var taskText: String = ""
    var taskbottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var shapeLayer: CAShapeLayer! {
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
        taskbottomConstraint = bottomConstraint
        dateLabel.text = newTaskPresenter.dateString
        shapeLayer = CAShapeLayer()
        categoryLabel.text = newTaskPresenter.categoryString
        textViewOutlet.becomeFirstResponder()
        textViewOutlet.delegate = self
        subView.layer.addSublayer(shapeLayer)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target:
            self, action: #selector(close))
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        costomtextView()
       
    }
    @objc func close() {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "New Task"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    private func costomtextView() {
        textViewOutlet.backgroundColor = .clear
        textViewOutlet.layer.borderWidth = 0
    }

    func configShapeLAyer(_ shapeLayer: CAShapeLayer) {
           //задаем отображение и указывем направление отрисовки фигуры
           shapeLayer.frame = textViewOutlet.bounds
           let path = UIBezierPath()
           path.move(to: CGPoint(x: textViewOutlet.frame.minX, y: textViewOutlet.frame.maxY ))    //начальная точка отрисовк
           path.addLine(to: CGPoint(x: textViewOutlet.frame.maxX, y: textViewOutlet.frame.maxY )) // конечная точка отрисовки
           shapeLayer.path = path.cgPath //добавляем путь отрисоки
       }
}

extension NewTaskViewController {

    func getCategoryString(categoryString: String) {
        categoryLabel.text = categoryString
        newTaskPresenter.categoryString = categoryString
    }

    func getDateString(dateString: String) {
        dateLabel.text = dateString
        newTaskPresenter.dateString = dateString
    }

    @IBAction func dateAction(_ sender: UIButton) {
        newTaskPresenter.dataAction(viewController: self)
    }
    @IBAction func categoryAction(_ sender: UIButton) {
        newTaskPresenter.categotyAction(viewController: self)
    }
    @IBAction func saveAction (_ sender: UIButton) {
        print("saveAction")
        taskText = textViewOutlet.text
        guard let navigationController = self.navigationController else { return }
        newTaskPresenter.save(navigationController: navigationController, viewController: self)  }

}
extension NewTaskViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = .black
        return true
    }
}
