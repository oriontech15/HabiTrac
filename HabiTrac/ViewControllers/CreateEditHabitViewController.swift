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

enum CreateEditMode {
    case create
    case edit
}

class CreateEditHabitViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    
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
    
    @IBOutlet weak var actionStack: UIStackView!
    
    // MARK: - PROPERTIES
    
    private var selectedCategory: Category?
    
    var presentingDelegate: ViewDismissDelegate?
    var mode: CreateEditMode = .create
    var habit: Habit?
    
    // MARK: - SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let habits = HabitController.shared.habits
        
        let physicalHabitsCount = habits.filter { CategoryController.shared.getCategory(from: $0.categoryID)?.name == "Physical" }.count
        let mentalHabitsCount = habits.filter { CategoryController.shared.getCategory(from: $0.categoryID)?.name == "Mental" }.count
        let spiritualHabitsCount = habits.filter { CategoryController.shared.getCategory(from: $0.categoryID)?.name == "Spiritual" }.count
        let socialHabitsCount = habits.filter { CategoryController.shared.getCategory(from: $0.categoryID)?.name == "Social" }.count
        
        setupWith(physicalCount: physicalHabitsCount, mentalCount: mentalHabitsCount, spiritualCount: spiritualHabitsCount, socialCount: socialHabitsCount)

        if mode == .edit {
            if let habit = self.habit {
                self.titleLabel.text = "Edit Habit"
                self.habitTitleTextField.text = habit.title
                let button = UIButton()
                switch CategoryController.shared.getCategory(from: habit.categoryID)?.type {
                case "Physical":
                    button.tag = 0
                    categoryButtonTapped(button)
                    break
                case "Mental":
                    button.tag = 1
                    categoryButtonTapped(button)
                    break
                case "Spiritual":
                    button.tag = 2
                    categoryButtonTapped(button)
                    break
                case "Social":
                    button.tag = 3
                    categoryButtonTapped(button)
                    break
                default:
                    break
                }
            }
        }
    }
    
    /// Sets up the view based on the number of existing habits for a category.
    /// If the habit count is equal to 4 the category is removed as an option.
    /// This helps the user to have a more narrow focus on a small amount of habits to master rather than a infinite set, which increases effectiveness of mastering the habit.
    /// - Parameters:
    ///   - physicalCount: Current count of physical habits
    ///   - mentalCount: Current count of mental habits
    ///   - spiritualCount: Current count of spiritual habits
    ///   - socialCount: Current count of social habits
    func setupWith(physicalCount: Int, mentalCount: Int, spiritualCount: Int, socialCount: Int) {
        if physicalCount == 4 { self.physicalCategoryButton.isHidden = true }
        if mentalCount == 4 { self.mentalCategoryButton.isHidden = true }
        if spiritualCount == 4 { self.spiritualCategoryButton.isHidden = true }
        if socialCount == 4 { self.socialCategoryButton.isHidden = true }
        
        self.physicalCategoryButton.setTitleColor(#colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1), for: .normal)
        self.mentalCategoryButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1), for: .normal)
        self.spiritualCategoryButton.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1), for: .normal)
        self.socialCategoryButton.setTitleColor(#colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1), for: .normal)
        
        self.physicalCategoryButton.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1).withAlphaComponent(0.1)
        self.mentalCategoryButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1).withAlphaComponent(0.1)
        self.spiritualCategoryButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1).withAlphaComponent(0.1)
        self.socialCategoryButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1).withAlphaComponent(0.1)
    }
    
    // MARK: - IBACTIONS
    
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
            self.createButton.setTitle(self.mode == .create ? "Create Physical Habit" : "Edit Physical Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Physical" }.first
            break
        case 1:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.mentalCategoryButton.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.mentalCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle(self.mode == .create ? "Create Mental Habit" : "Edit Mental Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Mental" }.first
            break
        case 2:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.spiritualCategoryButton.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.spiritualCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle(self.mode == .create ? "Create Spiritual Habit" : "Edit Spiritual Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Spiritual" }.first
            break
        case 3:
            self.seperatorView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.createButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.socialCategoryButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1)
            self.socialCategoryButton.setTitleColor(.systemBackground, for: .normal)
            self.createButton.setTitle(self.mode == .create ? "Create Social Habit" : "Edit Social Habit", for: .normal)
            self.selectedCategory = CategoryController.shared.categories.filter { $0.name == "Social" }.first
        default:
            break
        }
        
        self.actionStack.isHidden = false
    }
    
    @IBAction func createButtonTapped() {
        // Save new habit
        if let categoryID = self.selectedCategory?.id, let title = self.habitTitleTextField.text, self.habitTitleTextField.text != "" {
            if mode == .create {
                HabitController.shared.createHabit(categoryID: categoryID, title: title)
            } else {
                HabitController.shared.update(habit: self.habit!, with: categoryID, title: title)
            }
            self.presentingDelegate?.viewDismissing()
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error Saving", message: "Need more information,\nPlease make sure that you provide a title and select a category.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TEXTFIELD DELEGATE

extension CreateEditHabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
