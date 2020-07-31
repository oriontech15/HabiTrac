//
//  HabitController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/27/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation

class HabitController {
    static let shared = HabitController()
    
    var habits: [Habit] = []
    
    init() {
        getHabits()
    }
    
    func getHabits() {
        let realm = RealmController.shared.realm
       
        self.habits = Array(realm.objects(Habit.self))
    }
    
    func createHabit(categoryID: String, title: String) {
        let habit = Habit()
        habit.categoryID = categoryID
        habit.title = title
        habit.save(object: habit)
        getHabits()
    }
    
    func deleteHabit(habit: Habit) {
        let realm = RealmController.shared.realm
        
        if let habit = realm.object(ofType: Habit.self, forPrimaryKey: habit.id) {
            habit.delete(object: habit)
        }
    }
    
    func update(habit: Habit, with: Habit) {
        
    }
    
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
}
