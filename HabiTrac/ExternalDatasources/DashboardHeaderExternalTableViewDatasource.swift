//
//  DashboardHeaderExternalTableViewDatasource.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/19/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import UIKit

/// External Datasource for the header portion of the dashboard
class DashboardHeaderExternalTableViewDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerTableView: UITableView!
    @IBOutlet weak var dashboardTableView: UITableView!
    
    private var habits: [Habit] = []
    
    override init() {
        self.habits = HabitController.shared.habits
    }
    
    // Height for the collection view cells
    var rowHeight: CGFloat = 0 {
        didSet {
            headerTableView.reloadData()
        }
    }
    
    // Width for the collection view cells
    var rowWidth: CGFloat = 0
    
    // MARK: - TABLEVIEW SETUP
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habits.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! DashboardFooterTableViewCell
        cell.scrollDelegate = self
        cell.setup(rowHeight: self.rowHeight, rowWidth: self.rowWidth)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

// MARK: - EXTENSION

/// Helper function that communicates with the other tableviews to scroll ALL
/// collectionviews on the tableview cell when ONE collectionview scrolls
extension DashboardHeaderExternalTableViewDatasource: CollectionViewScrollingDelegate {
    func scrollingIsHappening(offset: CGPoint) {
        for cell in self.headerTableView.visibleCells {
            let cell = cell as! DashboardFooterTableViewCell
            cell.scroll(offset: offset)
        }
        
        for cell in self.dashboardTableView.visibleCells {
            if let cell = cell as? HabitDashboardTableViewCell {
                cell.scroll(offset: offset)
            }
            
            if let cell = cell as? TotalsTableViewCell {
                cell.scroll(offset: offset)
            }
        }
    }
}
