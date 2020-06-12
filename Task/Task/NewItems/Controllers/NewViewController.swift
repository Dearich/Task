//
//  NewViewController.swift
//  Task
//
//  Created by Азизбек on 09.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    let setDateNotificationID = "ru.azizbek.setDateComplitedNotificationID"
    let setCategoryNotificationID = "ru.azizbek.setCategoryNotificationID"
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
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishSetDate), name: NSNotification.Name(setDateNotificationID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishSetCategory), name: NSNotification.Name(setCategoryNotificationID), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(setDateNotificationID), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(setCategoryNotificationID), object: nil)
    }
    @objc func didFinishSetDate() {
        print("didFinishSetDate")
         let timestamp = UserDefaults.standard.double(forKey: "choosenDate")
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = NSLocale.current
        dateFormater.dateFormat = "dd MMMM HH:mm"
        let strDate = dateFormater.string(from: date)
        dateLabel.text = strDate
    }
    @objc func didFinishSetCategory () {
        guard let category = UserDefaults.standard.string(forKey: "choosenCategory") else { return }
        categoryLabel.text = category
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

        let myViewController = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        self.addChild(myViewController)
        myViewController.view.frame = self.view.frame
        self.view.addSubview(myViewController.view)

        myViewController.didMove(toParent: self)
    }

    @IBAction func categotyAction(_ sender: UIButton) {
        let myViewController = CategoryViewController(nibName: "CategoryViewController", bundle: nil)
               self.addChild(myViewController)
               myViewController.view.frame = self.view.frame
               self.view.addSubview(myViewController.view)

               myViewController.didMove(toParent: self)
    }

    @IBAction func createAction(_ sender: UIButton) {
        guard !textViewOutlet.text.isEmpty else { costomAlert(title: "Empty Task", discription: ""); return }
        guard categoryLabel.text != "Category" else { costomAlert(title: "Choose Category", discription: ""); return }
        var timestamp = UserDefaults.standard.double(forKey: "choosenDate")
        if timestamp == 0.0 {
            let date = Date().timeIntervalSince1970
            timestamp = date
        }
        CoreDataService.shared.saveTask(category: categoryLabel.text!, discription: textViewOutlet.text!, date: timestamp)
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
        updateTable()

    }
    private func costomAlert(title: String, discription: String) {
        let alert = UIAlertController(title: title, message: discription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)

    }

}
