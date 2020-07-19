//
//  RealmController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class RealmController {
    static let shared = RealmController()
    
    let realm = try! Realm()
}

protocol Syncable {
    func dictRepresentation() -> [String : AnyObject]
}

extension Syncable {
    // User Keys
    var firstNameKey: String { get { return "firstName" } }
    var lastNameKey: String { get { return "lastName" } }
    var emailKey: String { get { return "email" } }
    var phoneKey: String { get { return "phone" } }
    
    // Category Keys
    var catNameKey: String { get { return "catName" } }
    var habitsKey: String { get { return "habits" } }
    var typeKey: String { get { return "type" } }
    
    // Habit Keys
    var categoryKey: String { get { return "category" } }
    var titleKey: String { get { return "habitTitle" } }
    var completionDatesKey: String { get { return "completionDates" } }
}

protocol Realmifyable {
    var realm: Realm { get }
    
    func delete<T: Object & Syncable>(object: T)
    func save<T: Object & Syncable>(object: T)
    func objectExist <T: Object & Syncable>(object: T) -> Bool
}

extension Realmifyable {
    var realm: Realm { get { return try! Realm() } }
    
    func save<T: Object & Syncable>(object: T) {
        
        let dict = object.dictRepresentation()
        
        if let user = object as? User {
            
            if let firstName = dict[object.firstNameKey] as? String,
                let lastName = dict[object.lastNameKey] as? String,
                let email = dict[object.emailKey] as? String,
                let phone = dict[object.phoneKey] as? String {
                
                // If we arrive in this portion of the function then we know we are creating or updating a user to Realm as we have user properties in our generic object dictionary
                do {
                    try realm.write {
                        user.firstName = firstName
                        user.lastName = lastName
                        user.email = email
                        user.phone = phone
                        if !objectExist(object: user) {
                            realm.add(user)
                        }
                    }
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        if let category = object as? Category {
            if let catName = dict[object.catNameKey] as? String,
                let _ = dict[object.habitsKey],
                let type = dict[object.typeKey] as? String {
                
                
                // If we arrive in this portion of the function then we know we are creating or updating a user to Realm as we have user properties in our generic object dictionary
                do {
                    try realm.write {
                        category.name = catName
                        //category.habits = habits
                        category.type = type
                        if !objectExist(object: category) {
                            realm.add(category)
                        }
                    }
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        if let habit = object as? Habit {
            
            if let category = dict[object.categoryKey] as? String,
                let title = dict[object.titleKey] as? String,
                let dates = dict[object.completionDatesKey] as? List<String> {
                
                // If we arrive in this portion of the function then we know we are creating or updating a user to Realm as we have user properties in our generic object dictionary
                do {
                    try realm.write {
                        habit.categoryID = category
                        habit.title = title
                        habit.completionDates = dates
                        if !objectExist(object: habit) {
                            realm.add(habit)
                        }
                    }
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    func delete<T: Object & Syncable>(object: T) {
        
    }
    
    func objectExist <T: Object & Syncable>(object: T) -> Bool {
        if let user = object as? User {
            return realm.object(ofType: User.self, forPrimaryKey: user.userID) != nil
        }
        
        if let category = object as? Category {
            return realm.object(ofType: Category.self, forPrimaryKey: category.catID) != nil
        }
        
        if let habit = object as? Habit {
            return realm.object(ofType: Habit.self, forPrimaryKey: habit.id) != nil
        }
        
        return false
    }
}
