//
//  MockDataController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/15/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class MockDataController {
    
    static let shared = MockDataController()
    
    var categories: [Category] = []
    
    private func createCategories() {
        
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
    }
    
    func mockData() -> [Habit] {
        createCategories()
        var habits: [Habit] = []
        
        for index in 0..<16 {
            let habit = Habit()
            habit.title = "Habit \(index + 1)"
            
            habit.completionDates.append(objectsIn: [Date().toDateString(), Date().add(days: 2)!.toDateString(), Date().add(days: 3)!.toDateString(), Date().add(days: 6)!.toDateString(), Date().add(days: -2)!.toDateString()])
            
            switch index {
            case 0...3:
                habit.categoryID = categories[0].catID!
                try! RealmController.shared.realm.write {
                    categories[0].habits.append(habit)
                }
                break
            case 4...7:
                habit.categoryID = categories[1].catID!
                try! RealmController.shared.realm.write {
                    categories[1].habits.append(habit)
                }
                break
            case 8...11:
                habit.categoryID = categories[2].catID!
                try! RealmController.shared.realm.write {
                    categories[2].habits.append(habit)
                }
                break
            case 12...15:
                habit.categoryID = categories[3].catID!
                try! RealmController.shared.realm.write {
                    categories[3].habits.append(habit)
                }
                break
            default:
                break
            }
            
            habit.save(object: habit)
            habits.append(habit)
        }
        
        return habits
    }
}

extension Date {
    func add(days: Int) -> Date? {
        let currentDate = self
        var dateComponent = DateComponents()
        dateComponent.day = days
        
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return nil }
        
        return futureDate
    }
    
    static func getFirstDateOfMonth() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        let startOfMonth = calendar.date(from: components)
        return startOfMonth
    }
    
    static func getFirstDateOfWeek() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfMonth], from: date)
        
        let startOfWeek = calendar.date(from: components)
        return startOfWeek
    }
    
    static func getFirstDateOfYear() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        
        let startOfYear = calendar.date(from: components)
        return startOfYear
    }
    
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func getCurrentMonthString() -> String {
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth
    }
    
    func getCurrentDayString() -> String {
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth
    }
}
