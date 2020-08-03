//
//  AuthenticationViewController.swift
//  HabiTrac
//
//  Created by Justin Smith on 8/1/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum AuthMode {
    case signUp
    case login
}

class AuthenticationViewController: UIViewController {
    
    var authMode: AuthMode = .signUp
    
    @IBOutlet weak var emailView: CredintialsView!
    @IBOutlet weak var passwordView: CredintialsView!
    @IBOutlet weak var confirmPasswordView: CredintialsView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var switchAuthModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    private func setup() {
        if authMode == .signUp {
            confirmPasswordView.isHidden = false
        } else {
            confirmPasswordView.isHidden = true
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        
        if self.authMode == .signUp {
            if let email = emailView.textField.text, let password = passwordView.textField.text, password == confirmPasswordView.textField.text! {
                FirebaseController.shared.signUp(with: email, password: password, completion: { [weak self] (success) in
                    self?.performSegue(withIdentifier: "toHabitView", sender: nil)
                })
            }
        } else {
            if let email = emailView.textField.text, let password = passwordView.textField.text {
                FirebaseController.shared.signIn(with: email, password: password, completion: { [weak self] (success) in
                    self?.performSegue(withIdentifier: "toHabitView", sender: nil)
                })
                
            }
        }
    }
    
    @IBAction func switchAuthModeButton(_ sender: UIButton) {
        if self.authMode == .signUp {
            self.actionButton.setTitle("Login", for: .normal)
            self.switchAuthModeButton.setTitle("Sign Up", for: .normal)
            self.authMode = .login
        } else {
            self.actionButton.setTitle("Sign Up", for: .normal)
            self.switchAuthModeButton.setTitle("Login", for: .normal)
            self.authMode = .signUp
        }
        
        setup()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
