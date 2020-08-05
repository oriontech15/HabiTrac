//
//  DashboardFooterTableViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/16/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class TotalsTableViewCell: UITableViewCell {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var shadowStack: UIStackView!
    
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    
    
    // MARK: - PROPERTIES
    
    var scrollDelegate: CollectionViewScrollingDelegate?
    var scrollingBeingUpdated: Bool = false
    
    private var rowHeight: CGFloat = 0
    private var rowWidth: CGFloat = 0
    
    // MARK: - SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    deinit {
        self.scrollDelegate = nil
    }
    
    func setup(rowHeight: CGFloat, rowWidth: CGFloat) {
        self.rowWidth = rowWidth
        self.rowHeight = rowHeight
        self.collectionView.reloadData()
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
extension TotalsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let value = Date.getLastDateOfMonth()?.getDayValue() else { return 0 }
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayTotalCell", for: indexPath) as! TotalForDayCollectionViewCell
        
        cell.setupWithDate(date: Date.getFirstDateOfMonth()!.add(days: indexPath.row)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.rowHeight == 0 ? CGSize.zero : CGSize(width: self.rowWidth - 1, height: self.rowHeight - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollingBeingUpdated {
            self.scrollingBeingUpdated = true
            self.shadowStack.isHidden = false
            self.scrollDelegate?.scrollingIsHappening(offset: self.collectionView.contentOffset)
        }
    }
}
