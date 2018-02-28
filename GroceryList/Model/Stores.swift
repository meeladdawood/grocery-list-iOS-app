//
//  Stores.swift
//  GroceryList
//
//  Created by Meelad Dawood on 2/28/18.
//  Copyright © 2018 Meelad Dawood. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift

class Stores: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
