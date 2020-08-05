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
    
    // MARK: - CREATE
    /// Creates a static set of categories and saves them locally and on firebase
    func createCategories() {
        
        // Check if we have already created the required static categories if we haven't create them if we have get them
        let created = UserDefaults.standard.bool(forKey: "CategoriesCreatedKey")
        
        if !created {
            
            var physical = Category()
            physical.name = "Physical"
            physical.type = "Physical"
            physical.save(object: physical)
            physical.firSave()
            
            var mental = Category()
            mental.name = "Mental"
            mental.type = "Mental"
            mental.save(object: mental)
            mental.firSave()
            
            var spiritual = Category()
            spiritual.name = "Spiritual"
            spiritual.type = "Spiritual"
            spiritual.save(object: spiritual)
            spiritual.firSave()
            
            var social = Category()
            social.name = "Social"
            social.type = "Social"
            social.save(object: social)
            social.firSave()
            
            self.categories = [physical, mental, spiritual, social]
            
            UserDefaults.standard.set(true, forKey: "CategoriesCreatedKey")
        } else {
            let realm = RealmController.shared.realm
            
            self.categories = Array(realm.objects(Category.self))
        }
    }
    
    // MARK: - RETRIEVE
    /// Gets a category for the id parameter
    /// - Parameter id: The id for the category we are looking for
    /// - Returns: A category for the id passed in
    func getCategory(from id: String) -> Category? {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        
        return categories.filter(NSPredicate(format: "id == %@", id)).first
    }
    
    // MARK: - UPDATE
    /// Pulls the category data from database and save locally
    /// - Parameter completion: Block to execute after successfully pulling and saving category data
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
    
    // MARK: - DELETE
    
    /// Delete all categories in the local database
    func deleteAllLocal() {
        for category in categories {
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(category)
            }
        }
    }
    
    /// Removes a habit from the category
    /// - Parameter habit: Habit to be removed from habit list for category
    func removeHabit(habit: Habit) {
        guard let category = getCategory(from: habit.categoryID), let index = category.habits.index(of: habit.id) else { return }
        
        let realm = RealmController.shared.realm
        
        try! realm.write {
            category.habits.remove(at: index)
        }
    }
}
