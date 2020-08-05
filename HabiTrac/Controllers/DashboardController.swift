//
//  DashboardController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/19/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation

class DashboardController {
    
    static let shared = DashboardController()
    
    // MARK: - HELPER FUNCTIONS
    
    func getTotalHabitsCompletedForDay(date: String) -> Int {
        let habits = HabitController.shared.habits
        
        var count = 0
        for habit in habits {
            for completionDate in habit.completionDates {
                if completionDate == date {
                    count += 1
                }
            }
        }
        
        return count
    }
}
