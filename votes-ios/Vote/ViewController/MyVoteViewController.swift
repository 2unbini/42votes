//
//  MyVoteViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import UIKit

class MyVoteViewController: UITableViewController {
    
    // 테스트 데이터
    // 서버에서 데이터 가져올 땐 추가 메서드 구현 필요
    lazy var list: [QuestionVO] = {
        var ret = [QuestionVO]()
        
        for (id, question, isExpired) in myDataSet {
            let data = QuestionVO()
            data.id = id
            data.question = question
            data.isExpired = isExpired
            
            ret.append(data)
        }
        return ret
    }()
    
    lazy var voteData: Vote = {
        var ret = Vote()
        
        ret.question = QuestionVO()
        ret.answers = [AnswerVO]()
        
        ret.question?.question = "가장 좋아하는 42 과제는?"
        ret.question?.isExpired = false
        
        for (answer, count, id) in answerDataSet {
            let data = AnswerVO()
            data.answer = answer
            data.count = count
            data.id = id
            
            ret.answers?.append(data)
        }
        return ret
    }()

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row) selected...")
        
        guard let voteVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteVC") as? VoteViewController else {
            return
        }
        
        voteVC.voteData = voteData
        self.navigationController?.pushViewController(voteVC, animated: true)
        
        // question id를 이용해 데이터 세팅한 뒤 Vote뷰로 이동
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteList", for: indexPath)
        let label = cell.viewWithTag(Tag.voteList.rawValue) as? UILabel
        let labelText = "Q. " + (row.question ?? "")
        
        label?.numberOfLines = 0
        
        if row.isExpired == true {
            label?.text = labelText
        } else {
            label?.textColor = UIColor.lightGray
            label?.attributedText = labelText.strikeThrough()
        }
        
        return cell
    }
    
    // 각 행의 높이 지정
    // 글자 수가 일정 개수 이상이면 연산을 통해 높이 늘리기
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = self.list[indexPath.row]
        let height = CGFloat(50 + (row.question!.count / 25) * 30)
        
        return height
    }
    
    // 스와이프해서 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

