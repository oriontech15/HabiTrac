//
//  DashboardFooterExternalTableViewDatasource.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/19/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import UIKit

/// External Datasource for footer tableview on dashboard
class DashboardFooterExternalTableViewDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var habits: [Habit] = []
    
    override init() {
        self.habits = HabitController.shared.habits
    }
    
    // MARK: - TABLEVIEW SETUP
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habits.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell", for: indexPath)
        return cell
    }
}
