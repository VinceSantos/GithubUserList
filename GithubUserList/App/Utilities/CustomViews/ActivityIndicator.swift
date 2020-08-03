//
//  ActivityIndicator.swift
//  GithubUserList
//
//  Created by Vince Santos on 8/1/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit


class ActivityIndicator: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView()
    let shadowImage = UIImageView()
    
    func show(uiView: UIViewController) {
        
        shadowImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        shadowImage.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator.center = view.center
        
        uiView.view.addSubview(shadowImage)
        uiView.view.addSubview(activityIndicator)
        self.shadowImage.isHidden = false
    
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stop(uiView: UIViewController) {
        
        UIView.animate(withDuration: 0.3) {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.shadowImage.isHidden = true
        }
    }
    
}
