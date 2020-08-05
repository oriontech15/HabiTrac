//
//  DateCompletionCollectionViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/15/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class DateCompletionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var graphBarView: UIView!
    @IBOutlet weak var currentDateView: UIView!
    
    @IBOutlet weak var bottomHighlightView: UIView!
    
    @IBOutlet weak var completionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var completionViewHeight: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    
    private var date: Date!
    
    // MARK: - SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            self.completionViewWidth.constant = 4
            self.completionViewHeight.constant = 4
            
            self.completedView.layer.cornerRadius = 2
        } else {
            self.completionViewWidth.constant = 8
            self.completionViewHeight.constant = 8
            
            self.completedView.layer.cornerRadius = 4
        }
    }
    
    /// Sets up the collection view cell
    /// - Parameters:
    ///   - date: Date associated with the cell
    ///   - color: Color for the cell
    ///   - row: What tableview row it is on
    ///   - completed: Whether the cell should be marked as deleted or not
    ///   - highlight: Whether to highlight the cell for bar graph visibility
    ///   - last: Whether the highlight should be rounded because it is the last cell
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
            self.layoutIfNeeded()
        } else {
            self.graphBarView.roundCorners([], radius: 0)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            self.completionViewWidth.constant = 4
            self.completionViewHeight.constant = 4
            
            self.completedView.layer.cornerRadius = 2
        } else {
            self.completionViewWidth.constant = 8
            self.completionViewHeight.constant = 8
            
            self.completedView.layer.cornerRadius = 4
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.graphBarView.roundCorners([], radius: 0)
        self.bottomHighlightView.backgroundColor = .systemBackground
    }
}
