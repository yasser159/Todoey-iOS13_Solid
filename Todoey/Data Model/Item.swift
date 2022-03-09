//
//  Item.swift
//  Todoey
//
//  Created by Yasser Hajlaoui on 11/9/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String  = ""
    @objc dynamic var imageURL : String  = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
