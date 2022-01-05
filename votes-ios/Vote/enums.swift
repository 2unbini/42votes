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
    case myQuestion = "questions/my"
    case question = "questions/"
    case answer = "answers/"
    case login = "login"
    case register = "register"
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case noToken
    case expiredToken
}

// when login needed
let loginNeededDescription: String = "로그인이 필요한 서비스입니다."
let loginNeededButtonTitle: String = "로그인으로 이동"

// alert messages
let textFieldisEmpty: String = "입력되지 않은 항목이 있습니다."
let passwordNotConfirmed: String = "비밀번호를 다시 확인해주세요."
let signinFailed: String = "가입에 실패했습니다."
let loginFailed: String = "로그인에 실패했습니다."
let fetchFailed: String = "정보를 불러올 수 없습니다. 다시 시도해주세요."
let alreadyVoted: String = "이미 참여한 투표입니다."
let serverIsDown: String = "서버가 불안정합니다. 다시 시도해주세요."
let voteSucceeded: String = "투표가 완료되었습니다."
let invalidEndDate: String = "투표 종료 날짜가 유효하지 않습니다."
let bearer: String = "Bearer "
