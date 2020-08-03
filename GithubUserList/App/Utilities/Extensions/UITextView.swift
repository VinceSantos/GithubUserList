//
//  UITextView.swift
//  GithubUserList
//
//  Created by Vince Santos on 8/3/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

class TextViewAutoHeight: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeight), name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc func updateHeight() {
        var newFrame = frame

        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.frame = newFrame
    }
}
