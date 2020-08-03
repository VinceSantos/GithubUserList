//
//  UIView.swift
//  GithubUserList
//
//  Created by Vince Santos on 7/31/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    ///MULTIPLE TAP RECOGNIZERS TO BE USED AS CLOSURES INSTEAD OF MULTIPLE RECOGNIZERS
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    ///MULTIPLE TAP RECOGNIZERS TO BE USED AS CLOSURES INSTEAD OF MULTIPLE RECOGNIZERS
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setRoundView()
    {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    func anchorGlobalSet(topAnchor: NSLayoutYAxisAnchor, tConst: CGFloat, leftAnchor: NSLayoutXAxisAnchor, lConst: CGFloat, rightAnchor: NSLayoutXAxisAnchor, rConst: CGFloat, bottomAnchor: NSLayoutYAxisAnchor, bConst: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor, constant: tConst).isActive = true
        self.leftAnchor.constraint(equalTo: leftAnchor, constant: lConst).isActive = true
        self.rightAnchor.constraint(equalTo: rightAnchor, constant: rConst).isActive = true
        self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bConst).isActive = true
    }
}
