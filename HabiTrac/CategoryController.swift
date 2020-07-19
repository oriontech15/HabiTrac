//
//  CategoryController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/18/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryController {
    
    static var shared = CategoryController()
    
    func getCategory(from id: String) -> Category? {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        
        for cat in categories {
            print(cat.catID)
        }
        
        return categories.filter(NSPredicate(format: "catID == %@", id)).first
    }
}
