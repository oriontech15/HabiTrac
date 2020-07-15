//
//  Category.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

enum CategoryType: String {
    
    case mental = "Mental"
    case physical = "Physical"
    case spiritual = "Spiritual"
    case social = "Social"
    case none = ""
}

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var habits: [Habit] = []
    @objc dynamic var type: String = CategoryType.none.rawValue
    @objc dynamic var catID: String?
    
    required init() {
        catID = UUID().uuidString
    }
    
    override static func primaryKey() -> String? {
        return "catID"
    }
}

extension Category: Syncable {
    func dictRepresentation() -> [String : AnyObject] {
        return [:]
    }
}

extension Category: Realmifyable {
    
}
