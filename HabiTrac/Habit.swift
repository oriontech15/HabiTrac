//
//  Habit.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
     
    @objc dynamic var category: Category!
    @objc dynamic var title: String = ""
    @objc dynamic var completionDates: [Date] = []
}
