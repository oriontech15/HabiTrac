//
//  DateCompletionCollectionViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/15/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class DateCompletionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    private var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
    }
    
    func setupWithDate(date: Date, completed: Bool) {
        self.date = date
        completed ? (self.completedView.isHidden = false) : (self.completedView.isHidden = true)
    }
}
