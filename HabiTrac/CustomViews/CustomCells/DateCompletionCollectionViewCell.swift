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
    
    @IBOutlet weak var graphBarView: UIView!
    @IBOutlet weak var currentDateView: UIView!
    
    @IBOutlet weak var bottomHighlightView: UIView!
    
    private var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.borderView.layer.borderWidth = 0.5
//        self.borderView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
    }
    
    func setupWithDate(date: Date, color: UIColor, row: Int? = nil, completed: Bool, highlight: Bool, last: Bool = false) {
        self.date = date
        completed ? (self.completedView.isHidden = false) : (self.completedView.isHidden = true)
        
        if date.toDateString() == Date().toDateString() {
//            self.borderView.layer.cornerRadius = 5
            self.borderView.backgroundColor = color.withAlphaComponent(0.3)
            self.currentDateView.backgroundColor = UIColor.black.withAlphaComponent(0.06)
            //self.bottomHighlightView.backgroundColor = color.withAlphaComponent(0.3)
            self.completedView.backgroundColor = color.withAlphaComponent(1.0)
        } else {
            self.borderView.backgroundColor = color.withAlphaComponent(0.2)
            self.currentDateView.backgroundColor = .clear   
            self.completedView.backgroundColor = color
        }
        
        if highlight {
            //self.currentDateView.backgroundColor = .clear
            if date.toDateString() == Date().toDateString() {
                self.graphBarView.backgroundColor = color.withAlphaComponent(0.5)

            } else {
                self.graphBarView.backgroundColor = color.withAlphaComponent(0.3)
            }
        } else {
            self.graphBarView.backgroundColor = .clear
        }
        
        if last {
            self.graphBarView.roundCorners([.topLeft, .topRight], radius: 11)
        } else {
            self.graphBarView.roundCorners([], radius: 0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.graphBarView.roundCorners([], radius: 0)
        self.bottomHighlightView.backgroundColor = .white
    }
}
