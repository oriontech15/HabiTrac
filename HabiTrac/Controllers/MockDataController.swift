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
    var mockData: [Habit] = []
    
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
    
    func createMockData() {
        createCategories()
        var habits: [Habit] = []
        
        for index in 0..<16 {
            let habit = Habit()
            habit.title = "Habit \(index + 1)"
            
            for _ in 0..<30 {
                let random = arc4random_uniform(30)
                let dateString = Date.getFirstDateOfMonth()!.add(days: Int(random))!.toDateString()
                if !habit.completionDates.contains(dateString) {
                    habit.completionDates.append(dateString)
                }
            }
            
            switch index {
            case 0...3:
                habit.categoryID = categories[0].id
                try! RealmController.shared.realm.write {
                    categories[0].habits.append(habit)
                }
                break
            case 4...7:
                habit.categoryID = categories[1].id
                try! RealmController.shared.realm.write {
                    categories[1].habits.append(habit)
                }
                break
            case 8...11:
                habit.categoryID = categories[2].id
                try! RealmController.shared.realm.write {
                    categories[2].habits.append(habit)
                }
                break
            case 12...15:
                habit.categoryID = categories[3].id
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
        
        self.mockData = habits
    }
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
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
    
    static func getLastDateOfMonth() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: startComponents)!
        
        var lastDayComponents = DateComponents()
        lastDayComponents.month = 1
        lastDayComponents.day = -1
        
        let endOfMonth = Calendar.current.date(byAdding: lastDayComponents, to: startOfMonth)
        
        return endOfMonth
    }
    
    func getDayValue() -> Int {
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: now)
        guard let dayValue = Int(day) else { return 0 }
        return dayValue
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
    
    func toDateString(_ style: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        
        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func getCurrentWeekDates() -> [String] {
        let startOfWeek = Date().startOfWeek
        
        var dateStrings: [String] = []
        
        for i in 0..<7 {
            if let dateString = startOfWeek?.add(days: i)?.toDateString() {
                dateStrings.append(dateString)
            }
        }
        
        return dateStrings
    }
    
    func getCurrentMonthDates() -> [String] {
        let startOfMonth = Date.getFirstDateOfMonth()
        let endOfMonth = Date.getLastDateOfMonth()!
        
        let gregorian = Calendar(identifier: .gregorian)
        let totalDays = gregorian.component(.day, from: endOfMonth)
        
        var dateStrings: [String] = []
        
        for i in 0..<totalDays {
            if let dateString = startOfMonth?.add(days: i)?.toDateString() {
                dateStrings.append(dateString)
            }
        }
        
        return dateStrings
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
        let dayName = dateFormatter.string(from: now)
        return dayName
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
