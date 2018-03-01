//
//  Items.swift
//  GroceryList
//
//  Created by Meelad Dawood on 2/28/18.
//  Copyright © 2018 Meelad Dawood. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var price: Double = 0.00
    
    var parentCategory = LinkingObjects(fromType: Stores.self, property: "items")
}
