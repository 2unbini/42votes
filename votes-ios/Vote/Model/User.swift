//
//  User.swift
//  Vote
//
//  Created by 권은빈 on 2022/01/04.
//

import Foundation

// User Data to Login
struct User: Codable {
    var password: String?
    var username: String?
}

// User Data to Signin
struct NewUser: Codable {
    var email: String?
    var password: String?
    var username: String?
}

// 
struct Credentials: Codable {
    var user: User
    var token: String
    
    init(with token: String, _ user: User) {
        self.user = user
        self.token = token
    }
}
