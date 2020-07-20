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
    @IBOutlet weak var dateBackgroundView: UIView!
    
    private var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.borderView.layer.borderWidth = 0.5
        //        self.borderView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }
    
    func setupWithDate(date: Date) {
        self.date = date
        self.dateLabel.text = date.getCurrentDayString()
        
        if self.date.toDateString() == Date().toDateString() {
            self.dateBackgroundView.backgroundColor = .white
            self.dateBackgroundView.layer.cornerRadius = 5
            self.dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
            self.dateBackgroundView.layer.shadowOpacity = 0.35
            self.dateBackgroundView.layer.shadowOffset = .zero
            self.dateBackgroundView.layer.shadowRadius = 1
        } else {
            self.dateBackgroundView.backgroundColor = .white
            self.dateBackgroundView.layer.cornerRadius = 0
            self.dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
            self.dateBackgroundView.layer.shadowOpacity = 0.0
            self.dateBackgroundView.layer.shadowOffset = .zero
            self.dateBackgroundView.layer.shadowRadius = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dateBackgroundView.backgroundColor = .white
        self.dateBackgroundView.layer.cornerRadius = 0
        self.dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
        self.dateBackgroundView.layer.shadowOpacity = 0.0
        self.dateBackgroundView.layer.shadowOffset = .zero
        self.dateBackgroundView.layer.shadowRadius = 0
    }
}
