//
//  ProfileNoteTableViewCell.swift
//  GithubUserList
//
//  Created by Vince Santos on 8/3/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

class ProfileNoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
