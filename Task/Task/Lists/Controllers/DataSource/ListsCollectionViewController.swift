//
//  ListsCollectionViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

protocol ListsCollectionViewControllerDelegate: class {
    func didSelectItem(dataSource: ListsCollectionViewController, indexPath: Int)
}

class ListsCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

     var listItems = [CategoryList]()
    weak var listsCollectionViewControllerDelegate: ListsCollectionViewControllerDelegate?

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listItems.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ListsCollectionViewCell else { return UICollectionViewCell()}
        cell.listItem = listItems[indexPath.row]
        cell.setUpContentView()

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ListsCollectionViewCell {
                cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {

        UIView.animate(withDuration: 0.5) {
                   if let cell = collectionView.cellForItem(at: indexPath) as? ListsCollectionViewCell {
                    cell.contentView.transform = .identity
                    cell.contentView.backgroundColor = .white
                   }
               }

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

     func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        listsCollectionViewControllerDelegate?.didSelectItem(dataSource: self, indexPath: indexPath.row)

    }

}
