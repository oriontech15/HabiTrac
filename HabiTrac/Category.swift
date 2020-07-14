//
//  Category.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation

enum CategoryType: String {
    case mental = "Mental"
    case physical = "Physical"
    case spiritual = "Spiritual"
    case social = "Social"
}

struct Category {
    
    var name: String
    var habits: [Habit]
    var type: CategoryType
}
