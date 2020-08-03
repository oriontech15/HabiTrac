//
//  FirebaseController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/31/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

protocol FirebaseType: Syncable {
    var id: String { get set }
    var firType: String { get set }
    var database: DatabaseReference { get }
    
    mutating func firDelete()
    mutating func firSave()
    mutating func firUpdate()
}

class FirebaseController {
    
    static let shared = FirebaseController()
    var database: DatabaseReference!
    
    init() {
        database = Database.database().reference()
    }
    
    func signIn(with email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let result = authResult {
                let user = User()
                user.id = result.user.uid
                user.email = result.user.email ?? ""
                UserController.shared.currentUser = user
                
                CategoryController.shared.createCategories()
                completion(true)
            }
        }
    }
    
    func signUp(with email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let result = authResult {
                var user = User()
                user.id = result.user.uid
                user.email = result.user.email ?? ""
                UserController.shared.currentUser = user
                user.save(object: user)
                user.firSave()
                
                CategoryController.shared.createCategories()
                completion(true)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("ERROR SIGNING OUT: \(error.localizedDescription)")
        }
    }
}

extension FirebaseType {
    
    
    var database: DatabaseReference {
        get {
            return Database.database().reference()
        }
    }
    
    mutating func firDelete() {
        
    }
    
    mutating func firSave() {
        let dict = self.dictRepresentation()
        
        guard let user = UserController.shared.currentUser else { return }
        if firType == "users" {
            self.database.child(firType).child(user.id).setValue(dict)
        } else {
            self.database.child("users").child(user.id).child(firType).child(id).setValue(dict)

        }
    }
    
    mutating func firUpdate() {
        let dict = self.dictRepresentation()
        
        guard let user = UserController.shared.currentUser else { return }
        self.database.child("users").child(user.id).updateChildValues(dict)
    }
}
