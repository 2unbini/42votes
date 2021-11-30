//
//  NewVoteModel.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import Foundation

class NewVote {
    var question: String?
    var answers: [Answer]?
    var expiresAt: Date?
}

class Answer {
    var answer: String?
}
