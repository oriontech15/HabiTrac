//
//  ProfileViewController.swift
//  HabiTrac
//
//  Created by Justin Smith on 8/2/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

protocol SignOutDelegate {
    func signOut()
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var signOutDelegate: SignOutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped() {
        // Save values
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signOutButtonTapped() {
        FirebaseController.shared.signOut()
        self.dismiss(animated: true) {
            self.signOutDelegate?.signOut()
        }
    }
    private func setup() {
        guard let user = UserController.shared.currentUser else { return }
        self.nameLabel.text = user.firstName + " " + user.lastName
        self.emailLabel.text = user.email
        
        self.firstNameTextField.text = user.firstName
        self.lastNameTextField.text = user.lastName
        self.phoneTextField.text = user.phone
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
