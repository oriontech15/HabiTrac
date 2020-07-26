//
//  HabitListViewController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/25/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class HabitListViewController: UITableViewController {
    
    private var habits: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createButtonTapped() {
        self.performSegue(withIdentifier: "toCreateEditHabitView", sender: nil)
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
                print(vc)
            }
        }
    }

}

extension HabitListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitTableViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let habit = self.habits[indexPath.row]
        print(habit)
        self.performSegue(withIdentifier: "toCreateEditHabitView", sender: nil)
    }
}
