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

class FirebaseController {
    
    static let shared = FirebaseController()
    
    func signIn(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let result = authResult {
                print(result.additionalUserInfo)
            }
        }
    }
    
    func signUp(with email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let result = authResult {
              print(result.additionalUserInfo)
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
