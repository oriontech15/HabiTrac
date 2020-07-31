//
//  DashboardFooterTableViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/16/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class DashboardFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var shadowStack: UIStackView!
    
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    
    var scrollDelegate: CollectionViewScrollingDelegate?
    var scrollingBeingUpdated: Bool = false
    
    private var rowHeight: CGFloat = 0
    private var rowWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.collectionView.dataSource = self
        //self.collectionView.delegate = self
    }
    
    deinit {
        self.scrollDelegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(rowHeight: CGFloat, rowWidth: CGFloat) {
        self.rowHeight = rowHeight
        self.rowWidth = rowWidth
        self.habitTitleLabel.text = Date().getCurrentMonthString()
        self.collectionView.reloadData()
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

extension DashboardFooterTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let value = Date.getLastDateOfMonth()?.getDayValue() else { return 0 }
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colDateCell", for: indexPath) as! ColumnDateCollectionViewCell
        
        cell.setupWithDate(date: Date.getFirstDateOfMonth()!.add(days: indexPath.row)!)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollingBeingUpdated {
            self.scrollingBeingUpdated = true
            self.shadowStack.isHidden = false
            self.scrollDelegate?.scrollingIsHappening(offset: self.collectionView.contentOffset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.rowHeight == 0 ? CGSize.zero : CGSize(width: self.rowWidth - 1, height: self.rowHeight - 1)
    }
    
}
