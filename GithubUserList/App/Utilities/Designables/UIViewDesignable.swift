//
//  UIViewDesignable.swift
//  GithubUserList
//
//  Created by Vince Santos on 8/2/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

@IBDesignable class UIViewDesignable: UIView {
    var isViewRound = false

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var isRoundBounds: Bool = false {
        didSet {
            self.isViewRound = isRoundBounds
        }
    }
    
    override func draw(_ rect: CGRect) {
        if isViewRound == true {
            self.setRoundView()
        }
    }
}
