//
//  Profile module - ProfileModel.swift
//  GithubUserList
//
//  Created by Vince Santos on 02/08/2020.
//  Copyright © 2020 Vince Santos. All rights reserved.
//

import Foundation

struct ProfileModel: Codable {
    var id: Int?
    var name: String?
    var company: String?
    var blog: String?
    var bio: String?
    var followers: Int?
    var following: Int?
    var note: String?
}
