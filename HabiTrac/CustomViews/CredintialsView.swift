//
//  CredintialsView.swift
//  HabiTrac
//
//  Created by Justin Smith on 7/31/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import UIKit

class CredintialsView: UIView {
    
    @IBOutlet weak var textField: UITextField!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.10
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
    
}
