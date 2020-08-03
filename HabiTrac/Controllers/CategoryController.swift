//
//  CategoryController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/18/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryController {
    
    static var shared = CategoryController()
    
    var categories: [Category] = []
    
    func getCategory(from id: String) -> Category? {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        
        return categories.filter(NSPredicate(format: "id == %@", id)).first
    }
    
    func createCategories() {
        
        let created = UserDefaults.standard.bool(forKey: "CategoriesCreatedKey")
        
        if !created {
            
            let physical = Category()
            physical.name = "Physical"
            physical.type = "Physical"
            physical.save(object: physical)
            
            let mental = Category()
            mental.name = "Mental"
            mental.type = "Mental"
            mental.save(object: mental)
            
            let spiritual = Category()
            spiritual.name = "Spiritual"
            spiritual.type = "Spiritual"
            spiritual.save(object: spiritual)
            
            let social = Category()
            social.name = "Social"
            social.type = "Social"
            social.save(object: social)
            
            self.categories = [physical, mental, spiritual, social]
            
            UserDefaults.standard.set(true, forKey: "CategoriesCreatedKey")
        } else {
            let realm = RealmController.shared.realm
            
            self.categories = Array(realm.objects(Category.self))
        }
    }
}
