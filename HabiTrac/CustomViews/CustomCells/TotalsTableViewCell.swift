//
//  DashboardFooterTableViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/16/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class TotalsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var shadowStack: UIStackView!
    
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    
    var scrollDelegate: CollectionViewScrollingDelegate?
    var scrollingBeingUpdated: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.collectionView.dataSource = self
        //self.collectionView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup() {
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

extension TotalsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayTotalCell", for: indexPath) as! TotalForDayCollectionViewCell
        
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
}
