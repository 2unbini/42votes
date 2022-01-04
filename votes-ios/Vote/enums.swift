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

// TODO: View별 태그 나누기
enum Tag: Int {
    case invalid = -1
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
    case scrollView = 300
}

enum VoteViewTag: Int {
    case invalid = -1
    case startAnswer = 1
    case selected = 200
    case background = 300
    case textLabel = 400
}

enum VoteViewStatus {
    case beforeVote
    case afterVote
    case checkResult
    case expiredVote
}

enum URLs: String {
    case base = "http://42votes.site/v1/"
    case allQuestions = "questions/all"
    case myQuestion = "questions/my/"
    case question = "questions/"
    case answer = "answers/"
    case login = "login"
    case register = "register"
}
