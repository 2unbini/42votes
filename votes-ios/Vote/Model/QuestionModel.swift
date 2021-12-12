//
//  QuestionModel.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import Foundation

// 테스트 데이터셋
var dataSet = [
    (1, "나는 OO개발자가 되고 싶다!", false),
    (2, "넷플릭스 뭐가 더 재밌지이이이?오징어게임 vs 지옥", false),
    (3, "가장 힘들었던 42 과제는?", true),
    (4, "가장 좋아하는 42 과제는?", false),
    (5, "ABCDEFGABCDEFGABCDEFGABCDEFGABCDEFGABCDEFG", true),
    (6, "0123456789012345678901234567890123456789", false),
    (7, "💜", true),
    (8, "💛", false),
    (9, "테스트 ABC 123 💡", true),
    (10, "어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자어디까지가자보자", false),
    (11, "", true),
    (12, "", false)
]

var myDataSet = [
    (3, "가장 힘들었던 42 과제는?", true),
    (4, "가장 좋아하는 42 과제는?", false)
]

class QuestionVO {
    var id: Int?
    var question: String?
    var isExpired: Bool?
}
