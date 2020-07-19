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
    
    @IBOutlet weak var dashboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    let sectionHeaders: [String] = ["Physical", "Mental", "Spiritual", "Social"]
    
    private var mockData: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.mockData = MockDataController.shared.mockData()
        //        self.tableView.layer.borderWidth = 0.5
        //        self.tableView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        self.tableViewBackground.layer.shadowColor = UIColor.black.cgColor
//        self.tableViewBackground.layer.shadowOpacity = 0.35
//        self.tableViewBackground.layer.shadowOffset = .zero
//        self.tableViewBackground.layer.shadowRadius = 2
//        self.tableViewBackground.layer.cornerRadius = 12
        
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
    
    override func viewWillLayoutSubviews() {
        
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
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitTableViewCell
        cell.scrollDelegate = self
        cell.setup(with: self.mockData[indexPath.row])
        return cell
    }
}

extension DashboardViewController: CollectionViewScrollingDelegate {
    func scrollingIsHappening(offset: CGPoint) {
        for cell in self.dashboardTableView.visibleCells {
            if let cell = cell as? HabitTableViewCell {
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
