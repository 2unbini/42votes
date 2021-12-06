//
//  Tag.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import Foundation

// contentView의 subview의 tag는 2부터 시작
// 1: contentView
// 100: prototype cell의 label
// 201: addButton
// 202: deleteButton

enum Tag: Int {
    case contentView = 1
    case questionLabel = 2
    case questionTextView = 3
    case answerLabel = 4
    case defaultAnswerOne = 5
    case defaultAnswerTwo = 6
    case voteList = 100
    case addButton = 201
    case deleteButton = 202
    case dueDateLabel = 203
    case dateLabel = 204
    case dueDatePicker = 205
}

enum VoteViewStatus {
    case beforeVote
    case afterVote
    case checkResult
}
