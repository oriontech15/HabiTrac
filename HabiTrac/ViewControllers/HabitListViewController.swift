//
//  HabitListViewController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/25/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class HabitListViewController: UITableViewController {
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var previousDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    private let MAX_HABIT_COUNT = 16
    private var swipedHabit: Habit?
    
    private var currentDate: Date = Date() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var habits: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.habits = HabitController.shared.habits
        
        self.currentDateLabel.text = self.currentDate.toDateString(.long)
        self.tableView.reloadData()
        
        if self.currentDate.toDateString() == Date().toDateString() {
            self.nextDateButton.isEnabled = false
            self.nextDateButton.alpha = 0.5
        }
    }
    
    
    @IBAction func createButtonTapped() {
        if habits.count == MAX_HABIT_COUNT {
            let alert = UIAlertController(title: "Maximum Habits", message: "\nMaximum amount of habits have been created. \n\nHaving too many habits can halt progression rather than help it.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "toCreateEditHabitView", sender: ["mode" : "create"])
        }
    }
    
    @IBAction func previousDateButtonTapped() {
        self.currentDate = self.currentDate.add(days: -1)!
        self.currentDateLabel.text = self.currentDate.toDateString(.long)
        
        if self.currentDate.toDateString() == Date().toDateString() {
            self.nextDateButton.isEnabled = false
            self.nextDateButton.alpha = 0.5
        } else {
            self.nextDateButton.isEnabled = true
            self.nextDateButton.alpha = 1.0
        }
    }
    
    @IBAction func nextDateButtonTapped() {
        self.currentDate = self.currentDate.add(days: 1)!
        self.currentDateLabel.text = self.currentDate.toDateString(.long)
        
        if self.currentDate.toDateString() == Date().toDateString() {
            self.nextDateButton.isEnabled = false
            self.nextDateButton.alpha = 0.5
        } else {
            self.nextDateButton.isEnabled = true
            self.nextDateButton.alpha = 1.0
        }
    }
    
    @IBAction func profileButtonTapped() {
        self.performSegue(withIdentifier: "toProfileView", sender: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateEditHabitView" {
            if let vc = segue.destination as? CreateEditHabitViewController {
                vc.presentingDelegate = self
                if let sender = sender as? [String : String] {
                    let mode = sender["mode"]
                    if mode == "create" {
                        vc.mode = .create
                    } else {
                        vc.mode = .edit
                        vc.habit = swipedHabit
                    }
                }
                print(vc)
            }
        } else if segue.identifier == "toProfileView" {
            if let vc = segue.destination as? ProfileViewController {
                vc.signOutDelegate = self
            }
        }
    }
    
}

extension HabitListViewController: SignOutDelegate {
    func signOut() {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
}

extension HabitListViewController: ViewDismissDelegate {
    func viewDismissing() {
        self.habits = HabitController.shared.habits
        self.tableView.reloadData()
    }
}

extension HabitListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CategoryController.shared.categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habits.count == 0 ? 0 : self.habits.filter { CategoryController.shared.getCategory(from: $0.categoryID) == CategoryController.shared.categories[section] }.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitTableViewCell
        
        let habit = self.habits.filter { CategoryController.shared.getCategory(from: $0.categoryID) == CategoryController.shared.categories[indexPath.section] }[indexPath.row]
        cell.setup(with: habit, currentDate: self.currentDate)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HabitTableViewCell
        
        let habit = self.habits.filter { CategoryController.shared.getCategory(from: $0.categoryID) == CategoryController.shared.categories[indexPath.section] }[indexPath.row]
        let completed = habit.completionDates.contains(currentDate.toDateString())
        
        if completed {
            HabitController.shared.uncompletedHabitFor(dateString: currentDate.toDateString(), habit: habit)
        } else {
            HabitController.shared.completeHabitFor(date: currentDate.toDateString(), habit: habit)
        }
        
        cell.highlight(completed: habit.completionDates.contains(currentDate.toDateString()))
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit", handler: { (action, view, completion) in
            self.swipedHabit = self.habits.filter { CategoryController.shared.getCategory(from: $0.categoryID) == CategoryController.shared.categories[indexPath.section] }[indexPath.row]
            self.performSegue(withIdentifier: "toCreateEditHabitView", sender: ["mode" : "edit"])
            self.tableView.reloadData()
        })
        
        let category = CategoryController.shared.categories[indexPath.section]
        switch category.type {
        case CategoryType.physical.rawValue:
            action.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.2980392157, blue: 0.2901960784, alpha: 1).withAlphaComponent(0.9)
            break
        case CategoryType.mental.rawValue:
            action.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1).withAlphaComponent(0.9)
            break
        case CategoryType.spiritual.rawValue:
            action.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1).withAlphaComponent(0.9)
            break
        case CategoryType.social.rawValue:
            action.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8117647059, blue: 0.3215686275, alpha: 1).withAlphaComponent(0.9)
            break
        default:
            break
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        
        return swipeAction
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
            let habit = self.habits.filter { CategoryController.shared.getCategory(from: $0.categoryID) == CategoryController.shared.categories[indexPath.section] }[indexPath.row]
            HabitController.shared.deleteHabit(habit: habit) {
                HabitController.shared.getHabits()
                self.habits = HabitController.shared.habits
                CategoryController.shared.createCategories()
                self.tableView.reloadData()
            }
        })])
        
        return swipeAction
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CategoryController.shared.categories[section].name
    }
}
