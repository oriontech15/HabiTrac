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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var shadowStack: UIStackView!
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    
    private var tableViewRow: Int = 0
    var scrollDelegate: CollectionViewScrollingDelegate?
    var scrollingBeingUpdated: Bool = false
    private var habit: Habit!
    
    private var highlightCount = 0
    private var rowColor: UIColor = .white
    private var rowHeight: CGFloat = 0
    private var rowWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
    }
    
    deinit {
        self.scrollDelegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
            self.habitTitleLabel.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1).withAlphaComponent(0.9)
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
            self.habitTitleLabel.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0, alpha: 1).withAlphaComponent(0.9)
            self.rowColor = #colorLiteral(red: 0.9793888927, green: 0.7546933293, blue: 0, alpha: 1)
            break
        default:
            break
        }
    }
    
    func scroll(offset: CGPoint) {
        if offset.x == 0 {
            self.shadowStack.isHidden = true
        }
        
        self.collectionView.setContentOffset(offset, animated: false)
        //self.labelWidthConstraint.constant = 100 - offset.x
        self.scrollingBeingUpdated = false
    }
    
}

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
