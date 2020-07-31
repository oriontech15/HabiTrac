//
//  CreateEditHabitViewController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/25/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

protocol ViewDismissDelegate {
    func viewDismissing()
}

class CreateEditHabitViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var habitTitleTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var physicalCategoryButton: UIButton!
    @IBOutlet weak var mentalCategoryButton: UIButton!
    @IBOutlet weak var spiritualCategoryButton: UIButton!
    @IBOutlet weak var socialCategoryButton: UIButton!
    
    private var selectedCategory: Category?
    
    var presentingDelegate: ViewDismissDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupCategoryViews()
    }
    
    func setupCategoryViews() {
        self.physicalCategoryButton.setTitleColor(#colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1), for: .normal)
        self.mentalCategoryButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1), for: .normal)
        self.spiritualCategoryButton.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1), for: .normal)
        self.socialCategoryButton.setTitleColor(#colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1), for: .normal)
        
        self.physicalCategoryButton.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1).withAlphaComponent(0.1)
        self.mentalCategoryButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1).withAlphaComponent(0.1)
        self.spiritualCategoryButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1).withAlphaComponent(0.1)
        self.socialCategoryButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1).withAlphaComponent(0.1)
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        self.physicalCategoryButton.setTitleColor(#colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1), for: .normal)
        self.mentalCategoryButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1), for: .normal)
        self.spiritualCategoryButton.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1), for: .normal)
        self.socialCategoryButton.setTitleColor(#colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1), for: .normal)
        
        self.physicalCategoryButton.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1).withAlphaComponent(0.1)
        self.mentalCategoryButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1).withAlphaComponent(0.1)
        self.spiritualCategoryButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1).withAlphaComponent(0.1)
        self.socialCategoryButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1).withAlphaComponent(0.1)
        
        switch sender.tag {
        case 0:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            self.physicalCategoryButton.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            self.physicalCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle("Create Physical Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Physical" }.first
            break
        case 1:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.mentalCategoryButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.mentalCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle("Create Mental Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Mental" }.first
            break
        case 2:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.spiritualCategoryButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.spiritualCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle("Create Spiritual Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Spiritual" }.first
            break
        case 3:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.socialCategoryButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.socialCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle("Create Social Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Social" }.first
        default:
            break
        }
    }
    
    @IBAction func createButtonTapped() {
        // Save new habit
        if let categoryID = self.selectedCategory?.catID, let title = self.habitTitleTextField.text, self.habitTitleTextField.text != "" {
            HabitController.shared.createHabit(categoryID: categoryID, title: title)
            self.presentingDelegate?.viewDismissing()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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

extension CreateEditHabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
