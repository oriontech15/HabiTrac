//
//  Habit.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    
    @objc dynamic var categoryID: String = ""
    @objc dynamic var title: String = ""
    var completionDates: RealmSwift.List<String> = List<String>()
    @objc dynamic var id: String = ""
    
    required init() {
        self.id = UUID().uuidString
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["firType"]
    }
    
    var firType = "habits"
}

extension Habit: FirebaseType {
    
    func dictRepresentation() -> [String : AnyObject] {
        var dict: [String : AnyObject] = [:]
        dict[self.categoryKey] = self.categoryID as AnyObject
        dict[self.titleKey] = self.title as AnyObject
        dict[self.completionDatesKey] = Array(self.completionDates) as AnyObject
        return dict
    }
}

extension Habit: Realmifyable {
    
}
