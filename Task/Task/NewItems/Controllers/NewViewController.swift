//
//  NewViewController.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    let needToUpdateNotificationID = "ru.azizbek.needToUpdateTableNotificationID"

    @IBOutlet weak var textViewOutlet: UITextView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hightLabel: NSLayoutConstraint!
    @IBOutlet weak var hightTextView: NSLayoutConstraint!
    @IBOutlet weak var spaceLabelTextView: NSLayoutConstraint!
    @IBOutlet weak var spaceLabelView: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    var dateString: String?
    var categoryString: String?
    var timestamp: Double?
    let popUpViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
    let categoryViewController = CategoryViewController(nibName: "CategoryViewController", bundle: nil)
    let costomAlert = CostomAlertController()

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
        timestamp = 0.0
        categoryViewController.categoryViewControllerDelegate = self
        popUpViewController.popUpViewControllerDelegate = self
        if categoryString != nil && categoryString != "All"{
            categoryLabel.text = categoryString
        }
        shapeLayer = CAShapeLayer()
        textViewOutlet.delegate = self
        textViewOutlet.becomeFirstResponder()
        subView.layer.addSublayer(shapeLayer)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target:
            self, action: #selector(close))
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        costomtextView()

        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc private func handle(keyboardShowNotification notification: Notification) {

        print("Keyboard show notification")

        if let userInfo = notification.userInfo,

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
        print("viewWillAppear")
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "New Task"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        setUpDate()
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

    func updateTable() {
        NotificationCenter.default.post(name: NSNotification.Name(needToUpdateNotificationID), object: self)
    }

    @IBAction func dataAction(_ sender: UIButton) {

        self.addChild(popUpViewController)
        popUpViewController.view.frame = self.view.frame
        self.view.addSubview(popUpViewController.view)
        print("dataAction")
        popUpViewController.didMove(toParent: self)
    }

    @IBAction func categotyAction(_ sender: UIButton) {
               self.addChild(categoryViewController)
               categoryViewController.view.frame = self.view.frame
               self.view.addSubview(categoryViewController.view)

               categoryViewController.didMove(toParent: self)
    }

    @IBAction func createAction(_ sender: UIButton) {
        guard !textViewOutlet.text.isEmpty else { costomAlert.setup(title: "Empty Task", discription: ""); return }
        guard categoryLabel.text != "Category" else { costomAlert.setup(title: "Choose Category", discription: ""); return }

        if timestamp == 0.0 {
            let date = Date().timeIntervalSince1970
            timestamp = date
        }
         guard let timestamp = timestamp else { return }
        CoreDataService.shared.saveTask(category: categoryLabel.text!, discription: textViewOutlet.text!, date: timestamp)
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
        updateTable()

    }
}
// POPUP VIEW DELEGATE

extension NewViewController: CategoryViewControllerDelegate, PopUpViewControllerDelegate {

    func getDate(timestamp: Double) {

        self.timestamp = timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = NSLocale.current
        dateFormater.dateFormat = "dd MMMM HH:mm"
        let strDate = dateFormater.string(from: date)
        dateLabel.text = strDate
    }

    func getCategory(category: String) {
        categoryLabel.text = category
    }

}
