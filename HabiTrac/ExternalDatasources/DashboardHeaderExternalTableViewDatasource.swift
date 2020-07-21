//
//  DashboardHeaderExternalTableViewDatasource.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/19/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import Foundation
import UIKit

class DashboardHeaderExternalTableViewDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerTableView: UITableView!
    @IBOutlet weak var dashboardTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! DashboardFooterTableViewCell
        cell.scrollDelegate = self
        cell.setup()
        return cell
    }
}

extension DashboardHeaderExternalTableViewDatasource: CollectionViewScrollingDelegate {
    func scrollingIsHappening(offset: CGPoint) {
        for cell in self.headerTableView.visibleCells {
            let cell = cell as! DashboardFooterTableViewCell
            cell.scroll(offset: offset)
        }
        
        for cell in self.dashboardTableView.visibleCells {
            if let cell = cell as? HabitTableViewCell {
                cell.scroll(offset: offset)
            }
            
            if let cell = cell as? TotalsTableViewCell {
                cell.scroll(offset: offset)
            }
        }
    }
}
