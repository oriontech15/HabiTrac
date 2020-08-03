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
    var habits: RealmSwift.List<Habit> = List<Habit>()
    @objc dynamic var type: String = CategoryType.none.rawValue
    @objc dynamic var id: String = ""
    
    required init() {
        id = UUID().uuidString
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["firType"]
    }
    
    var firType = "categories"
}

extension Category: FirebaseType {
    func dictRepresentation() -> [String : AnyObject] {
        var dict: [String : AnyObject] = [:]
        dict[self.catNameKey] = self.name as AnyObject
        dict[self.typeKey] = self.type as AnyObject
        dict[self.habitsKey] = Array(self.habits).map { $0.id } as AnyObject
        return dict
    }
}

extension Category: Realmifyable {
    
}
