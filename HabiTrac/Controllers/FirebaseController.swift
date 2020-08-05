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
    
    mutating func firDelete(completion: @escaping () -> Void)
    mutating func firSave()
    mutating func firUpdate()
}

class FirebaseController {
    
    static let shared = FirebaseController()
    var database: DatabaseReference!
    
    init() {
        database = Database.database().reference()
    }
    
    func checkAuth() -> Bool {
        guard let firUser = Auth.auth().currentUser else { return false }
        
        let user = User()
        user.email = firUser.email ?? ""
        user.id = firUser.uid

        database.child(user.firType).child(user.id).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : AnyObject] else { return }
            if let firstName = dict[user.firstNameKey] as? String {
                user.firstName = firstName
            }
            if let lastName = dict[user.lastNameKey] as? String {
                user.lastName = lastName
            }
            if let phone = dict[user.phoneKey] as? String {
                user.phone = phone 
            }
        }
        
        UserController.shared.currentUser = user
        CategoryController.shared.createCategories()
        return true
    }
    
    func signIn(with email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            
            if let result = authResult {
                let user = User()
                user.id = result.user.uid
                user.email = result.user.email ?? ""
                UserController.shared.currentUser = user
                UserDefaults.standard.set(true, forKey: "CategoriesCreatedKey")
                
                CategoryController.shared.pullAndUpdateLocal {
                    HabitController.shared.pullAndUpdateLocal {
                        completion(true)
                    }
                }
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
                user.firUpdate()
                
                CategoryController.shared.createCategories()
                completion(true)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserController.shared.currentUser = nil
            UserDefaults.standard.set(nil, forKey: "CategoriesCreatedKey")
            
            HabitController.shared.deleteAllLocal()
            CategoryController.shared.deleteAllLocal()
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
    
    mutating func firDelete(completion: @escaping () -> Void) {
        guard let user = UserController.shared.currentUser else { return }
        self.database.child("users").child(user.id).child(firType).child(id).removeValue { (error, ref) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            completion()
        }
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
        if firType == "users" {
            self.database.child(firType).child(user.id).updateChildValues(dict)
        } else {
            self.database.child("users").child(user.id).child(firType).child(id).updateChildValues(dict)
        }
    }
}
