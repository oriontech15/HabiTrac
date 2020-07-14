//
//  User.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var userID: String?
    @objc dynamic var phone: String = ""
    
    // Need to add primeary key
    override static func primaryKey() -> String? {
        return "userID"
    }
}

extension User: Syncable {
    func dictRepresentation() -> [String : AnyObject] {
        return [:]
    }
}

extension User: Realmifyable {
    
}
