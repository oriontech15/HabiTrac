//
//  MockDataController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/15/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation

class MockDataController {
    
    static let shared = MockDataController()
    
    var categories: [Category] = []
    
    private func createCategories() {
        
        let physical = Category()
        physical.name = "Physical"
        physical.type = "Physical"
        
        let mental = Category()
        mental.name = "Mental"
        mental.type = "Mental"
        
        let spiritual = Category()
        spiritual.name = "Spiritual"
        spiritual.type = "Spiritual"
        
        let social = Category()
        social.name = "Social"
        social.type = "Social"
        
        self.categories = [physical, mental, spiritual, social]
    }
    
    func mockData() -> [Habit] {
        createCategories()
        var habits: [Habit] = []
        
        for index in 0..<16 {
            let habit = Habit()
            habit.title = "Habit \(index)"
            habit.completionDates = [Date(), Date().add(days: 2)!, Date().add(days: 3)!, Date().add(days: 6)!, Date().add(days: -2)!]
            
            switch index {
            case 0...3:
                habit.categoryID = categories[0].catID!
                categories[0].habits.append(habit)
                break
            case 4...7:
                habit.categoryID = categories[1].catID!
                categories[1].habits.append(habit)
                break
            case 8...11:
                habit.categoryID = categories[2].catID!
                categories[2].habits.append(habit)
                break
            case 12...15:
                habit.categoryID = categories[3].catID!
                categories[3].habits.append(habit)
                break
            default:
                break
            }
            
            habits.append(habit)
        }
        
        return habits
    }
}

extension Date {
    func add(days: Int) -> Date? {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = days
        
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return nil }
        
        return futureDate
    }
    
    func getFirstDateOfMonth() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        
        let startOfMonth = calendar.date(from: components)
        return startOfMonth
    }
    
    func getFirstDateOfWeek() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfMonth], from: date)
        
        let startOfWeek = calendar.date(from: components)
        return startOfWeek
    }
    
    func getFirstDateOfYear() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        
        let startOfYear = calendar.date(from: components)
        return startOfYear
    }
}
