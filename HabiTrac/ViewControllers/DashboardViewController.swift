//
//  DashboardViewController.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var headerTableView: UITableView!
    @IBOutlet weak var tableViewBackground: UIView!
    @IBOutlet weak var trackedHabitsButton: UIButton!
    
    @IBOutlet weak var headerTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var keyViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dashboardHeaderDatasource: DashboardHeaderExternalTableViewDatasource!
    
    let sectionHeaders: [String] = ["Physical", "Mental", "Spiritual", "Social"]
    
    private var habits: [Habit] = []
    private var rowHeight: CGFloat = 0
    private var rowWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
        self.dashboardTableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        self.view.layoutIfNeeded()
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            self.dashboardTableView.isScrollEnabled = true
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            self.dashboardTableView.isScrollEnabled = true
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            self.dashboardTableView.isScrollEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let habits =  HabitController.shared.habits
        
        self.habits = habits.sorted {
            guard let categoryName1 = CategoryController.shared.getCategory(from: $0.categoryID)?.name else { return false }
            guard let categoryName2 = CategoryController.shared.getCategory(from: $1.categoryID)?.name else { return false }
            return categoryName1 < categoryName2
            //$0.categoryID == $1.categoryID
        }
        
        self.headerTableViewHeight.constant = 80
        self.keyViewHeight.constant = 30
        
        let otherViewHeights: CGFloat = self.headerTableViewHeight.constant + self.keyViewHeight.constant + self.tabBarController!.tabBar.frame.height + 15
        self.rowHeight = CGFloat(self.view.frame.height - otherViewHeights) / (CGFloat(self.habits.count + 2))
        let rowWidth = CGFloat(self.view.frame.width - 185) / CGFloat(Date.getLastDateOfMonth()?.getDayValue() ?? 30)
        self.rowWidth = (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) ? rowWidth : self.rowHeight
        
        self.headerTableViewHeight.constant = 50 + self.rowHeight
        
        self.dashboardHeaderDatasource.rowHeight = self.rowHeight
        self.dashboardHeaderDatasource.rowWidth = self.rowWidth
        
        self.headerTableView.reloadData()
        self.dashboardTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habits.count == 0 ? 0 : self.habits.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.habits.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath) as! TotalsTableViewCell
            cell.scrollDelegate = self
            cell.setup(rowHeight: self.rowHeight, rowWidth: self.rowWidth)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitDashboardCell", for: indexPath) as! HabitDashboardTableViewCell
        cell.scrollDelegate = self
        let habit = self.habits[indexPath.row]
        cell.setup(with: habit, rowHeight: self.rowHeight, rowWidth: self.rowWidth, row: indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if UIDevice.current.orientation != .landscapeLeft && UIDevice.current.orientation != .landscapeRight {
            cell.alpha = 0
            
            let transform = CATransform3DMakeTranslation(0, 20, 0)
            cell.layer.transform = transform
            
            let delay = Double(self.habits.count - indexPath.row) * 0.075
            
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8,  options: [], animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            if let headerView = self.headerTableView.tableHeaderView {
                headerView.frame.size = CGSize(width: headerView.frame.width, height: 0)
                
                self.headerTableViewHeight.constant = 30
                self.keyViewHeight.constant = 30
                
                let otherViewHeights: CGFloat = self.headerTableViewHeight.constant + self.keyViewHeight.constant + self.tabBarController!.tabBar.frame.height
                self.rowHeight = CGFloat(self.view.frame.height - otherViewHeights) / (CGFloat(self.habits.count + 1))
                self.rowWidth = CGFloat(self.view.frame.width - 185) / CGFloat(Date.getLastDateOfMonth()?.getDayValue() ?? 30)

                self.headerTableViewHeight.constant = self.rowHeight
                
                self.dashboardHeaderDatasource.rowHeight = self.rowHeight
                self.dashboardHeaderDatasource.rowWidth = self.rowWidth
                
                self.headerTableView.reloadData()
                self.dashboardTableView.reloadData()
            }
        } else {
            if let headerView = self.headerTableView.tableHeaderView {
                headerView.frame.size = CGSize(width: headerView.frame.width, height: 50)
                self.headerTableViewHeight.constant = 80
                self.keyViewHeight.constant = 30
                
                let otherViewHeights: CGFloat = self.headerTableViewHeight.constant + self.keyViewHeight.constant + self.tabBarController!.tabBar.frame.height + 15
                self.rowHeight = CGFloat(self.view.frame.height - otherViewHeights) / (CGFloat(self.habits.count + 2))
                self.rowWidth = self.rowHeight
                
                self.headerTableViewHeight.constant = 50 + self.rowHeight
                
                self.dashboardHeaderDatasource.rowHeight = self.rowHeight
                self.dashboardHeaderDatasource.rowWidth = self.rowWidth
                
                self.headerTableView.reloadData()
                self.dashboardTableView.reloadData()
            }
        }
    }
}

extension DashboardViewController: CollectionViewScrollingDelegate {
    func scrollingIsHappening(offset: CGPoint) {
        for cell in self.dashboardTableView.visibleCells {
            if let cell = cell as? HabitDashboardTableViewCell {
                cell.scroll(offset: offset)
            }
            
            if let cell = cell as? TotalsTableViewCell {
                cell.scroll(offset: offset)
            }
        }
        
        for cell in self.headerTableView.visibleCells {
            if let cell = cell as? DashboardFooterTableViewCell {
                cell.scroll(offset: offset)
            }
        }
    }
}
