//
//  HabitTableViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/14/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

protocol CollectionViewScrollingDelegate {
    func scrollingIsHappening(offset: CGPoint)
}

class HabitDashboardTableViewCell: UITableViewCell {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var shadowStack: UIStackView!
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    
    private var tableViewRow: Int = 0
    var scrollDelegate: CollectionViewScrollingDelegate?
    var scrollingBeingUpdated: Bool = false
    private var habit: Habit!
    
    private var highlightCount = 0
    private var rowColor: UIColor = .white
    private var rowHeight: CGFloat = 0
    private var rowWidth: CGFloat = 0
    
    // MARK: - SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        self.scrollDelegate = nil
    }
    
    func setup(with habit: Habit, rowHeight: CGFloat, rowWidth: CGFloat, row: Int) {
        self.habit = habit
        self.habitTitleLabel.text = habit.title
        self.habitTitleLabel.textAlignment = .center
        
        self.tableViewRow = row
        self.rowHeight = rowHeight
        self.rowWidth = rowWidth
        self.collectionView.reloadData()
        
        guard let category = CategoryController.shared.getCategory(from: self.habit.categoryID) else { return }
        self.habitTitleLabel.textColor = .white
        switch category.type {
        case CategoryType.physical.rawValue:
            self.habitTitleLabel.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.2980392157, blue: 0.2901960784, alpha: 1).withAlphaComponent(0.9)
            self.rowColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            break
        case CategoryType.mental.rawValue:
            self.habitTitleLabel.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1).withAlphaComponent(0.9)
            self.rowColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            break
        case CategoryType.spiritual.rawValue:
            self.habitTitleLabel.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1).withAlphaComponent(0.9)
            self.rowColor = #colorLiteral(red: 0.04566108435, green: 0.605656743, blue: 0.8518152237, alpha: 1)
            break
        case CategoryType.social.rawValue:
            self.habitTitleLabel.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8117647059, blue: 0.3215686275, alpha: 1).withAlphaComponent(0.9)
            self.rowColor = #colorLiteral(red: 0.9960784314, green: 0.8117647059, blue: 0.3215686275, alpha: 1)
            break
        default:
            break
        }
    }
    
    /// Helper function to scroll the cell when it or other collectionviews are scrolled
    /// - Parameter offset: The offset at which it or other collectionviews have been scrolled
    func scroll(offset: CGPoint) {
        if offset.x == 0 {
            self.shadowStack.isHidden = true
        }
        
        self.collectionView.setContentOffset(offset, animated: false)
        self.scrollingBeingUpdated = false
    }
    
}

// MARK: CELL COLLECTION VIEW SETUP

// Sets up the collection view for each cell. Used to build out dashboard
extension HabitDashboardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let value = Date.getLastDateOfMonth()?.getDayValue() else { return 0 }
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCompletionCollectionViewCell
        
        guard let date = Date.getFirstDateOfMonth()?.add(days: indexPath.row) else { return cell }
        let completed = self.habit.completionDates.contains(date.toDateString())
        let range = (HabitController.shared.habits.count - DashboardController.shared.getTotalHabitsCompletedForDay(date: date.toDateString())) ... HabitController.shared.habits.count
        
        if range ~= tableViewRow {
            cell.setupWithDate(date: date, color: rowColor, row: tableViewRow, completed: completed, highlight: true, last: tableViewRow == (HabitController.shared.habits.count - DashboardController.shared.getTotalHabitsCompletedForDay(date: date.toDateString())))
        } else {
            cell.setupWithDate(date: date, color: rowColor, completed: completed, highlight: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return self.rowHeight == 0 ? CGSize.zero : CGSize(width: self.rowWidth - 1, height: self.rowHeight - 1)
        } else {
            return self.rowHeight == 0 ? CGSize.zero : CGSize(width: self.rowWidth - 1, height: self.rowHeight - 1)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollingBeingUpdated {
            self.scrollingBeingUpdated = true
            self.shadowStack.isHidden = false
            self.scrollDelegate?.scrollingIsHappening(offset: self.collectionView.contentOffset)
        }
    }
}
