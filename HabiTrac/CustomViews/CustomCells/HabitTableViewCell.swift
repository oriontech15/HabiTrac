//
//  HabitTableViewCell.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/25/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var selectedBackground: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var selectedBackgroundWidth: NSLayoutConstraint!
    
    private var completed: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundWidth.constant = 0
        self.checkImageView.alpha = 0.0
    }
    
    func highlight(completed: Bool) {
        if completed {
            UIView.animate(withDuration: 0.65, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                self.selectedBackgroundWidth.constant = self.bounds.width
                
                self.habitTitleLabel.textColor = .white
                self.layoutIfNeeded()
            }, completion: nil )
            
            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.checkImageView.alpha = 1.0
                self.checkImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.checkImageView.transform = CGAffineTransform.identity
            }) { (complete) in
                if complete {
                    UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                        self.checkImageView.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
            }
            self.completed = false
        } else {
            UIView.animate(withDuration: 0.65, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                self.selectedBackgroundWidth.constant = 0
                
                self.habitTitleLabel.textColor = .label
                self.layoutIfNeeded()
            }, completion: nil )
            
            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.checkImageView.alpha = 0.0
            }, completion: nil)
            
            self.completed = true
        }
    }
    
    func setup(with habit: Habit, currentDate: Date) {
        self.habitTitleLabel.text = habit.title
        
        guard let category = CategoryController.shared.getCategory(from: habit.categoryID) else { return }
        switch category.type {
        case CategoryType.physical.rawValue:
            self.habitTitleLabel.textColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            self.colorView.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1)
            self.selectedBackground.backgroundColor = #colorLiteral(red: 0.996235311, green: 0.299339205, blue: 0.2904318571, alpha: 1).withAlphaComponent(0.8)
            break
        case CategoryType.mental.rawValue:
            self.habitTitleLabel.textColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.colorView.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1)
            self.selectedBackground.backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.7294117647, blue: 0.4901960784, alpha: 1).withAlphaComponent(0.8)
            break
        case CategoryType.spiritual.rawValue:
            self.habitTitleLabel.textColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.colorView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1)
            self.selectedBackground.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6039215686, blue: 0.8509803922, alpha: 1).withAlphaComponent(0.8)
            break
        case CategoryType.social.rawValue:
            self.habitTitleLabel.textColor = #colorLiteral(red: 0.9960784314, green: 0.8117647059, blue: 0.3215686275, alpha: 1)
            self.colorView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8117647059, blue: 0.3215686275, alpha: 1)
            self.selectedBackground.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8117647059, blue: 0.3215686275, alpha: 1).withAlphaComponent(0.8)
            break
        default:
            break
        }
        
        self.completed = habit.completionDates.contains(currentDate.toDateString())
        self.highlight(completed: self.completed)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.completed = false
        self.selectedBackgroundWidth.constant = 0
    }
}
