//
//  VoteModel.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import Foundation

// Create New Vote

class NewVote {
    var question: String?
    var answers: [Answer]?
    var expiresAt: Date?
}

class Answer {
    var answer: String?
}

// Set Vote Info

class Vote {
    var answers: [AnswerVO]?
    var question: QuestionVO?
}
