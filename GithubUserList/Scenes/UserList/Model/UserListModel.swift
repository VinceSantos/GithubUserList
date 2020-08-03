//
//  UserList module - UserListModel.swift
//  GithubUserList
//
//  Created by Vince Santos on 31/07/2020.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import Foundation

struct UserListModel: Codable {
    var id: Int?
    var login: String?
    var repos_url: String?
    var avatar_url: String
}
