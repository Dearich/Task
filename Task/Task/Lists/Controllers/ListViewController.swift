//
//  ListViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = ListsCollectionViewController()
    var listItems = [ListsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         collectionView.register(ListsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        dataSource.listsCollectionViewControllerDelegate = self
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        getLists()

    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
   

       @objc func menu() {
           print("menu")
       }

    @IBAction func addButtonAction(_ sender: UIButton) {
      let stroyboard = UIStoryboard(name:"NewItemStoryboard" , bundle: nil)
      let vc = stroyboard.instantiateViewController(identifier: "NewViewController") as! NewViewController
      navigationController?.show(vc, sender: sender)
    }
}

extension ListViewController {

    func setUpNavigationBar() {
         guard let navigationController = self.navigationController else { return }
               navigationController.navigationBar.prefersLargeTitles = true
               navigationController.navigationBar.isHidden = false
               navigationItem.largeTitleDisplayMode = .automatic
               navigationItem.title = "Lists"
            
//                navigationController.navigationBar.barTintColor =
        
               navigationItem.setHidesBackButton(true, animated: true)
               navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-4"), landscapeImagePhone: UIImage(named: "menu"), style: .done, target: self, action: #selector(menu))
               navigationController.navigationBar.tintColor = UIColor.black
    }
    
    func getLists()  {
              UseJson.shared.parse {[weak self] (listsOfItems, error) in
                  if error != nil {
                      print(error!.localizedDescription)
                  }else {
                      guard let dictionaryList = listsOfItems else { return }
                    self?.dataSource.listItems = dictionaryList.lists
                    self?.listItems = dictionaryList.lists
                    
                  }
              }
          }
    
}

extension ListViewController: ListsCollectionViewControllerDelegate {
    func didSelectItem(dataSource: ListsCollectionViewController, indexPath: Int) {
        
        let stroyboard = UIStoryboard(name:"OneCategoty" , bundle: nil)
        let vc = stroyboard.instantiateViewController(identifier: "OneCategoryViewController") as! OneCategoryViewController
        vc.headerString = listItems[indexPath].name
        navigationController?.show(vc, sender: self)
    }
    
    
}
