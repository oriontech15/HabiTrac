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
    
    @IBOutlet weak var weekTotalLabel: UILabel!
    @IBOutlet weak var monthTotalLabel: UILabel!
    
    @IBOutlet weak var totalStackView: UIStackView!
    @IBOutlet weak var editStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    private var inEditMode = false
    
    let user = UserController.shared.currentUser
    var signOutDelegate: SignOutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        self.weekTotalLabel.text = "\(HabitController.shared.getWeekTotals())"
        self.monthTotalLabel.text = "\(HabitController.shared.getMonthTotals())"
        setup()
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped() {
        // Save values
        guard var user = self.user else { return }
        let realm = RealmController.shared.realm
                
        do {
            try realm.write {
                
                if let email = emailTextField.text {
                    user.email = email
                }
                
                if let firstname = firstNameTextField.text {
                    user.firstName = firstname
                }
                
                if let lastname = lastNameTextField.text {
                    user.lastName = lastname
                }
                
                if !user.objectExist(object: user) {
                    realm.add(user)
                } else {
                    realm.add(user, update: .modified)
                }
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        user.firUpdate()
        
        self.emailLabel.text = user.email
        self.nameLabel.text = user.firstName + " " + user.lastName
        UserController.shared.currentUser = user
        
        editButtonTapped()
    }
    
    @IBAction func editButtonTapped() {
        
        if !inEditMode {

            self.emailLabel.isHidden = true
            
            self.emailTextField.text = user?.email
            self.firstNameTextField.text = user?.firstName
            self.lastNameTextField.text = user?.lastName
            
            self.editStackView.isHidden = false
            self.totalStackView.isHidden = true

            self.editButton.setImage(UIImage(systemName: "pencil.slash"), for: .normal)
            self.actionButton.isHidden = false
            self.inEditMode = true
        } else {
            self.emailLabel.isHidden = false
            
            self.editStackView.isHidden = true
            self.totalStackView.isHidden = false
            
            self.editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            self.actionButton.isHidden = true
            self.inEditMode = false
        }
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

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
