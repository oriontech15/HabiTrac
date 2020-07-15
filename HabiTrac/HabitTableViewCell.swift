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

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var scrollDelegate: CollectionViewScrollingDelegate?
    var scrollingBeingUpdated: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with habit: Habit) {
        
        self.collectionView.reloadData()
    }
    
    func scroll(offset: CGPoint) {
        self.collectionView.setContentOffset(offset, animated: false)
        self.scrollingBeingUpdated = false
    }

}

extension HabitTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("SCROLLING")
        if !scrollingBeingUpdated {
            self.scrollingBeingUpdated = true
            self.scrollDelegate?.scrollingIsHappening(offset: self.collectionView.contentOffset)
        }
    }
}
