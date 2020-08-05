//
//  ColumnDateCollectionViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/16/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class TotalForDayCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var currentDateBackgroundView: UIView!

    // MARK: - PROPERTIES

    private var date: Date!
    
    // MARK: - SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWithDate(date: Date) {
        self.date = date
        self.totalLabel.text = "\(DashboardController.shared.getTotalHabitsCompletedForDay(date: date.toDateString()))"
        
        if self.date.toDateString() == Date().toDateString() {
            self.currentDateBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.dateBackgroundView.layer.cornerRadius = 5
            self.dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
            self.dateBackgroundView.layer.shadowOpacity = 0.35
            self.dateBackgroundView.layer.shadowOffset = .zero
            self.dateBackgroundView.layer.shadowRadius = 1
        } else {
            self.currentDateBackgroundView.backgroundColor = .clear
            self.dateBackgroundView.layer.cornerRadius = 0
            self.dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
            self.dateBackgroundView.layer.shadowOpacity = 0.0
            self.dateBackgroundView.layer.shadowOffset = .zero
            self.dateBackgroundView.layer.shadowRadius = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.currentDateBackgroundView.backgroundColor = .clear
        self.dateBackgroundView.layer.cornerRadius = 0
        self.dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
        self.dateBackgroundView.layer.shadowOpacity = 0.0
        self.dateBackgroundView.layer.shadowOffset = .zero
        self.dateBackgroundView.layer.shadowRadius = 0
    }
}
