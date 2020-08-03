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
    
    private var currentDate: Date = Date() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var habits: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.habits = HabitController.shared.habits
        self.currentDateLabel.text = self.currentDate.toDateString(.long)
        self.tableView.reloadData()
    }
    

    @IBAction func createButtonTapped() {
        self.performSegue(withIdentifier: "toCreateEditHabitView", sender: nil)
    }
    
    @IBAction func previousDateButtonTapped() {
        self.currentDate = self.currentDate.add(days: -1)!
        self.currentDateLabel.text = self.currentDate.toDateString(.long)
    }
    
    @IBAction func nextDateButtonTapped() {
        self.currentDate = self.currentDate.add(days: 1)!
        self.currentDateLabel.text = self.currentDate.toDateString(.long)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CategoryController.shared.categories[section].name
    }
}
