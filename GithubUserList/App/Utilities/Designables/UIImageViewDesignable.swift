//
//  UIImageViewDesignable.swift
//  GithubUserList
//
//  Created by Vince Santos on 7/31/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIImageViewDesignable: UIImageView {
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
    
    @IBInspectable var cornerRatio: CGFloat {
        get {
            return layer.cornerRadius / frame.width
        }

        set {
            // Make sure that it's between 0.0 and 1.0. If not, restrict it
            // to that range.
            let normalizedRatio = max(0.0, min(1.0, newValue))
            layer.cornerRadius = frame.width * normalizedRatio
        }
    }
}
