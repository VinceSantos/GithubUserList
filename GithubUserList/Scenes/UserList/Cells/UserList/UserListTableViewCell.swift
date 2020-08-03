//
//  UserListTableViewCell.swift
//  GithubUserList
//
//  Created by Vince Santos on 7/31/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gitImage: UIImageViewDesignable!
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var gitUserName: UILabel!
    @IBOutlet weak var details: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
