//
//  Extensions.swift
//  HabiTrac
//
//  Created by Justin Smith on 8/5/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

/// APP RELATED EXTENSIONS
extension Date {
    
    /// Gets the date for the start of the week, Monday being considered the start day
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    /// Gets the date for the end of the week, Sunday being considered the end day
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    /// Take a date and adds either a positive or negative number of days to it
    /// - Parameter days: Number of days to be added to the date
    /// - Returns: Date based on the result of adding or subtracting the days
    func add(days: Int) -> Date? {
        let currentDate = self
        var dateComponent = DateComponents()
        dateComponent.day = days
        
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return nil }
        
        return futureDate
    }
    
    /// Gets the date for the first day of the current month
    /// - Returns: Date of the first day of the current month
    static func getFirstDateOfMonth() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        let startOfMonth = calendar.date(from: components)
        return startOfMonth
    }
    
    /// Gets the date for the last day of the current month
    /// - Returns: Date of the last day of the current month
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
    
    
    /// Gets the day as a number for a date
    /// - Returns: Day number value
    func getDayValue() -> Int {
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: now)
        guard let dayValue = Int(day) else { return 0 }
        return dayValue
    }
    
    /// Gets the first date of the current year
    /// - Returns: Date for the first day of the current year
    static func getFirstDateOfYear() -> Date? {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        
        let startOfYear = calendar.date(from: components)
        return startOfYear
    }
    
    /// Gets a string representation of a date
    /// - Parameter style: Date style of the date string to be returned
    /// - Returns: String representation of date
    func toDateString(_ style: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        
        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    /// Gets all dates for the current week, beginning with Monday
    /// - Returns: Array containing all the dates for the current week
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
    
    /// Gets all dates for the current month
    /// - Returns: Array containing all dates for the current month
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
    
    /// Gets month string of current month
    /// - Returns: String value of current month, i.e. (January)
    func getCurrentMonthString() -> String {
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth
    }
    
    /// Gets current day string
    /// - Returns: String value of current day
    func getCurrentDayString() -> String {
        let now = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let dayName = dateFormatter.string(from: now)
        return dayName
    }
}

extension UIView {
    
    /// Rounds the specified corners of a view
    /// - Parameters:
    ///   - corners: Array of corners to round
    ///   - radius: Radius to round corners
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
