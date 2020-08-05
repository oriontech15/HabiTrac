//
//  HabitController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/27/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class HabitController {
    static let shared = HabitController()
    
    var habits: [Habit] = []
    
    init() {
        getHabits()
    }
    
    // MARK: - CREATE
    
    /// Creates a habit
    /// - Parameters:
    ///   - categoryID: Category id for the selected category
    ///   - title: Title for the habit
    func createHabit(categoryID: String, title: String) {
        var habit = Habit()
        habit.categoryID = categoryID
        habit.title = title
        habit.save(object: habit)
        habit.firSave()
        getHabits()
    }
    
    // MARK: - RETRIEVE
    
    /// Get habits from local database
    func getHabits() {
        let realm = RealmController.shared.realm
       
        self.habits = Array(realm.objects(Habit.self))
    }
    
    // MARK: - UPDATE
    
    /// Updates a habit with new values
    /// - Parameters:
    ///   - habit: Habit to be updated
    ///   - categoryID: New category id for habit
    ///   - title: New title for habit
    func update(habit: Habit, with categoryID: String, title: String) {
        
        var habit = habit
        let realm = RealmController.shared.realm
        
        try! realm.write {
            habit.categoryID = categoryID
            habit.title = title
            if !habit.objectExist(object: habit) {
                realm.add(habit)
            } else {
                realm.add(habit, update: .modified)
            }
        }
        
        habit.firUpdate()
        
        getHabits()
    }
    
    /// Pulls and updates local database with values from Firebase database
    /// - Parameter completion: Block to be executed upon successful completion
    func pullAndUpdateLocal(completion: @escaping () -> Void) {
        let realm = RealmController.shared.realm
        
        guard let user = UserController.shared.currentUser, let database = FirebaseController.shared.database else { completion(); return }
        database.child(user.firType).child(user.id).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String : AnyObject], let dict = value["habits"] as? [String : [String : AnyObject]] else { completion(); return }
            for key in dict.keys {
                if let habDict = dict[key] {
                    _ = Habit(with: key, dict: habDict)
                }
            }
            
            self.habits = Array(realm.objects(Habit.self))
            
            completion()
        }
    }
    
    // MARK: - DELETE
    
    /// Deletes a habit
    /// - Parameters:
    ///   - habit: Habit to be deleted
    ///   - completion: Block to be executed upon successfully deleting the habit
    func deleteHabit(habit: Habit, completion: @escaping () -> Void) {
        let realm = RealmController.shared.realm
        
        if var habit = realm.object(ofType: Habit.self, forPrimaryKey: habit.id) {
            habit.firDelete {
                CategoryController.shared.removeHabit(habit: habit)
                habit.delete(object: habit)
                completion()
            }
        }
    }
    
    /// Deletes all habits in the local database
    func deleteAllLocal() {
        for habit in habits {
            let realm = RealmController.shared.realm
            
            try! realm.write {
                realm.delete(habit)
            }
        }
    }
    
    
    // MARK: - HELPER FUNCTIONS
    
    /// Removes the date from the completionDates array for a habit, which uncompletes the habit for that date
    /// - Parameters:
    ///   - dateString: Date to remove from completionDates for habit
    ///   - habit: Habit to uncomplete
    func uncompletedHabitFor(dateString: String, habit: Habit) {
        guard let index = habit.completionDates.index(of: dateString) else { return }
        
        let realm = RealmController.shared.realm
        
        do {
            try realm.write {
                habit.completionDates.remove(at: index)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Adds the date to the completionDates array for a habit, which completes the habit for that date
    /// - Parameters:
    ///   - date: Date to add to completionDates for habit
    ///   - habit: Habit to complete
    func completeHabitFor(date: String, habit: Habit) {
        let realm = RealmController.shared.realm
        
        do {
            try realm.write {
                habit.completionDates.append(date)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Gets the total completed habits for the current week time period,
    /// with Monday being the first day of the week
    /// - Returns: Total completed habits for the current week
    func getWeekTotals() -> Int {
        let habits = self.habits
        let dates = Date().getCurrentWeekDates()
        
        var total = 0
        for habit in habits {
            for date in habit.completionDates {
                if dates.contains(date) {
                    total += 1
                }
            }
        }
        
        return total
    }
    
    /// Gets the total completed habits for the current month time period
    /// - Returns: Total completed habits for the current month
    func getMonthTotals() -> Int {
        let habits = self.habits
        let dates = Date().getCurrentMonthDates()
        
        var total = 0
        for habit in habits {
            for date in habit.completionDates {
                if dates.contains(date) {
                    total += 1
                }
            }
        }
        
        return total
    }
}
