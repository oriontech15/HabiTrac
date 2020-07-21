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
    
    @IBOutlet weak var physicalLabelView: UIView!
    @IBOutlet weak var mentalLabelView: UIView!
    @IBOutlet weak var spiritualLabelView: UIView!
    @IBOutlet weak var socialLabelView: UIView!
    
    @IBOutlet weak var dashboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    let sectionHeaders: [String] = ["Physical", "Mental", "Spiritual", "Social"]
    
    private var mockData: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.mockData = MockDataController.shared.mockData
        
        
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
        return mockData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == mockData.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath) as! TotalsTableViewCell
            cell.scrollDelegate = self
            cell.setup()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitTableViewCell
        cell.scrollDelegate = self
        let habit = self.mockData[indexPath.row]
        cell.setup(with: habit, row: indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        let transform = CATransform3DMakeTranslation(0, 20, 0)
        cell.layer.transform = transform
        
        let delay = Double(mockData.count - indexPath.row) * 0.1
        
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8,  options: [], animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}

extension DashboardViewController: CollectionViewScrollingDelegate {
    func scrollingIsHappening(offset: CGPoint) {
        for cell in self.dashboardTableView.visibleCells {
            if let cell = cell as? HabitTableViewCell {
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
