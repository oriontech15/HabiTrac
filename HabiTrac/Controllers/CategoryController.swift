//
//  CategoryController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/18/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class CategoryController {
    
    static var shared = CategoryController()
    
    var categories: [Category] = []
    
    func getCategory(from id: String) -> Category? {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        
        return categories.filter(NSPredicate(format: "id == %@", id)).first
    }
    
    func deleteAllLocal() {
        for category in categories {
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(category)
            }
        }
    }
    
    func removeHabit(habit: Habit) {
        guard let category = getCategory(from: habit.categoryID), let index = category.habits.index(of: habit.id) else { return }
        
        let realm = RealmController.shared.realm
        
        try! realm.write {
            category.habits.remove(at: index)
        }
    }
    
    func pullAndUpdateLocal(completion: @escaping () -> Void) {
        let realm = RealmController.shared.realm
        
        guard let user = UserController.shared.currentUser, let database = FirebaseController.shared.database else { completion(); return }
        database.child(user.firType).child(user.id).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String : AnyObject], let dict = value["categories"] as? [String : [String : AnyObject]] else { completion(); return }
            for key in dict.keys {
                if let catDict = dict[key] {
                    _ = Category(with: key, dict: catDict)
                }
            }
            
            self.categories = Array(realm.objects(Category.self))
            
            completion()
        }
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
