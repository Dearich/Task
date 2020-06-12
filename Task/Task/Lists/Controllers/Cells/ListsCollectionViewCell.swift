//
//  ListsCollectionViewCell.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class ListsCollectionViewCell: UICollectionViewCell {

    let width = (UIScreen.main.bounds.width - 55)/2

    var listItem: CategoryList!
    var subText = ""

    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()

    let subView: UIView = {
        let view = UIView()
        return view

    }()

    func setUpContentView() {
        if listItem.name == "All"{
            CoreDataService.shared.fetchTasks {[weak self] (tasks) in

                    self?.subText = "\(tasks.count) tasks"

            }
        } else {
            subText = "\(listItem.tasks?.allObjects.count ?? 0) tasks"
        }

        contentView.backgroundColor = #colorLiteral(red: 0.9999126792, green: 1, blue: 0.9998814464, alpha: 1)
        contentView.layer.cornerRadius = 5
       print( contentView.frame.width)
        contentView.addSubview(subView)

        subView.addConstraintsWithFormat(format: "H:|-[v0(\(width - 15))]", views: subView)
        subView.addConstraintsWithFormat(format: "V:|-[v0]-|", views: subView)

        subView.addSubview(image)
        subView.addSubview(title)
        subView.addSubview(subTitle)

        image.addConstraintsWithFormat(format: "H:|-10-[v0(60)]", views: image)
        image.addConstraintsWithFormat(format: "V:|-10-[v0(60)]", views: image)

        title.text = listItem.name
        title.addConstraintsWithFormat(format: "H:|-15-[v0]-|", views: title)

        subTitle.text = subText
        subTitle.addConstraintsWithFormat(format: "H:|-15-[v0]-|", views: subTitle)

        image.addConstraintsWithFormat(format: "V:[v0]-[v1]-15-|", views: title, subTitle)
        image.image = UIImage(named: listItem.imageName!)
    }
}
