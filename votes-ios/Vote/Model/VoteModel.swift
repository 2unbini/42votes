//
//  VoteModel.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import Foundation

// Fetch Seleced Vote

class Vote: Codable {
    var question: Question?
    var answers: [Answer]?
}

// New Vote

class NewVote: Codable {
    var answers: [String]?
    var question: String?
    var expiresAt: Date?
}

// User's vote

class UserVote: Codable {
    var answerId: Int?
    var questionId: Int?
}
