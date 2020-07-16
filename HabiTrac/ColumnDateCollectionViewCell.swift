//
//  ColumnDateCollectionViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/16/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class ColumnDateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
    }
    
    func setupWithDate(date: Date) {
        self.date = date
        self.dateLabel.text = date.getCurrentDayString()
    }
}
