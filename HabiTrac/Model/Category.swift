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
    var habits: RealmSwift.List<String> = List<String>()
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
        dict[self.habitsKey] = Array(self.habits) as AnyObject
        return dict
    }
    
    convenience init?(with id: String, dict: [String : AnyObject]) {
        self.init()
        guard let name = dict[catNameKey] as? String,
            let type = dict[typeKey] as? String else { return nil }
        
        let realm = RealmController.shared.realm
        
        try! realm.write {
            self.id = id
            self.name = name
            self.type = type
            if let habits = dict[habitsKey] as? [String] {
                habits.forEach { self.habits.append($0) }
            }
            
            if !objectExist(object: self) {
                realm.add(self)
            } else {
                realm.add(self, update: .modified)
            }
        }
    }
}

extension Category: Realmifyable {
    
}
