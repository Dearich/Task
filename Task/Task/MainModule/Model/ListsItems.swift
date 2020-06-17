//
//  ListsItems.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

struct ListsItem: Codable {
    var name: String
    var image: String
}

struct ListsOfItems: Codable {
    var lists: [ListsItem]

}
