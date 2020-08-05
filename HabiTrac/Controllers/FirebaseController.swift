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
    
    // MARK: - AUTHENTICATION
    
    /// Checks if there is a user logged in already
    /// - Returns: true if a user is logged in, false otherwise
    func checkAuth() -> Bool {
        guard let firUser = Auth.auth().currentUser else { return false }
        
        let user = User()
        user.email = firUser.email ?? ""
        user.id = firUser.uid

        // Pull user data from Firebase
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
    
    
    /// Signs the user in with the provided credintials
    /// - Parameters:
    ///   - email: The email the user entered to sign up with
    ///   - password: The password to go along with the email
    ///   - completion: The block that gets executed after signin completes successfully
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
    
    /// Signs the user up with an email password combo
    /// - Parameters:
    ///   - email: The email the user entered to sign up with
    ///   - password: The password to go along with the email
    ///   - completion: The block that gets executed after signup completes successfully
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
    
    /// Attempts to sign the user out, and clears the local database
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


// MARK: FIREBASE TYPE EXTENSION

extension FirebaseType {
    
    // Database reference for the Firebase Database
    var database: DatabaseReference {
        get {
            return Database.database().reference()
        }
    }
    
    /// Delete protocol function for FirebaseType objects that deletes the object on the database
    /// - Parameter completion: Executes the block passed in after the object has been successfully deleted
    mutating func firDelete(completion: @escaping () -> Void) {
        guard let user = UserController.shared.currentUser else { return }
        self.database.child("users").child(user.id).child(firType).child(id).removeValue { (error, ref) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            completion()
        }
    }
    
    /// Save protocol function for FirebaseType objects that saves/creates a new value on the Firebase database
    mutating func firSave() {
        let dict = self.dictRepresentation()
        
        guard let user = UserController.shared.currentUser else { return }
        if firType == "users" {
            self.database.child(firType).child(user.id).setValue(dict)
        } else {
            self.database.child("users").child(user.id).child(firType).child(id).setValue(dict)

        }
    }
    
    /// Update protocol function for FirebaseType objects that updates child values on the Firebase database
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
