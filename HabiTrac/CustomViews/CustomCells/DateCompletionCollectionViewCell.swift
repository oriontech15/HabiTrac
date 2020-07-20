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
    
    @IBOutlet weak var bottomHighlightView: UIView!
    
    private var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.borderView.layer.borderWidth = 0.5
//        self.borderView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
    }
    
    func setupWithDate(date: Date, color: UIColor, completed: Bool, highlight: Bool) {
        self.date = date
        completed ? (self.completedView.isHidden = false) : (self.completedView.isHidden = true)
        
        if date.toDateString() == Date().toDateString() {
//            self.borderView.layer.cornerRadius = 5
            self.borderView.backgroundColor = color.withAlphaComponent(0.4)
            //self.bottomHighlightView.backgroundColor = color.withAlphaComponent(0.3)
            self.completedView.backgroundColor = color.withAlphaComponent(1.0)
        } else {
            self.borderView.backgroundColor = color.withAlphaComponent(0.2)
            self.completedView.backgroundColor = color
        }
        
        if highlight {
            self.borderView.backgroundColor = color.withAlphaComponent(0.75)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.bottomHighlightView.backgroundColor = .white
    }
}
