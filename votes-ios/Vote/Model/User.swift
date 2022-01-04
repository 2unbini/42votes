//
//  User.swift
//  Vote
//
//  Created by 권은빈 on 2022/01/04.
//

import Foundation

struct User: Codable {
    var password: String?
    var username: String?
}

struct NewUser: Codable {
    var email: String?
    var password: String?
    var username: String?
}

class Login {
    var user: User
    var token: String
    
    init(with token: String, _ user: User) {
        self.user = user
        self.token = token
    }
}
