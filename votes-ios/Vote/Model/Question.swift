//
//  QuestionModel.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import Foundation

class Question: Codable {
    var id: Int?
    var question: String?
    var isExpired: Bool?
    var expiresAt: Date?
}
