//
//  ListsCollectionViewController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

protocol CategoryCollectionDataSourceDelegate: class {
    func didSelectItem(dataSource: CategoryCollectionDataSource, indexPath: Int)
}

class CategoryCollectionDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

     var listItems = [CategoryList]()
    weak var categoryCollectionDataSourceDelegate: CategoryCollectionDataSourceDelegate?

    // MARK: UICollectionViewDataSource

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listItems.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? ListsCollectionViewCell else { return UICollectionViewCell()}
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        categoryCollectionDataSourceDelegate?.didSelectItem(dataSource: self, indexPath: indexPath.row)

    }

}
