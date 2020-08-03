//
//  ProfileHeaderTableViewCell.swift
//  GithubUserList
//
//  Created by Vince Santos on 8/2/20.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var profileFollowing: UILabel!
    @IBOutlet weak var profileFollowers: UILabel!
    @IBOutlet weak var profileHeader: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
