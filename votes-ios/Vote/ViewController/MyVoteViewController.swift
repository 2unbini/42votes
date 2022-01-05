//
//  MyVoteViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import UIKit

class MyVoteViewController: UITableViewController {
    
    let hasUserData: Bool = UserDefaults.standard.bool(forKey: "hasUserData")
    var myVoteList = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // user 로그인 정보가 있으면, MyVoteList 생성
        if hasUserData {
            configureRefreshControl()
            getMyVoteList()
        }
        
        // user 로그인 정보가 없으면, 로그인 라벨/버튼 뷰 생성
        if !hasUserData {
            let needLoginView = NeedLoginView(frame: CGRect(), self)
            self.view.addSubview(needLoginView)
            needLoginView.configureConstraints(self.view)
        }
    }
    
    // 테이블뷰를 구성하는 데이터가 몇 행인지 리턴
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myVoteList.count
    }
    
    // 행 선택시, 선택한 투표 데이터 서버로부터 받아오고 VoteView로 이동
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let questionId = myVoteList[indexPath.row].id else { fatalError("nil found in questionId") }
        getVoteData(from: questionId)
    }

    // 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.myVoteList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteList", for: indexPath)
        let label = cell.viewWithTag(Tag.voteList.rawValue) as? UILabel
        let labelText = "Q. " + (row.question ?? "")
        
        label?.numberOfLines = 0
        
        // 라벨의 속성 초기화
        label?.textColor = UIColor.black
        label?.attributedText = NSAttributedString(string: "")
        
        if row.isExpired == false {
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
        let row = self.myVoteList[indexPath.row]
        let height = CGFloat(50 + (row.question!.count / 25) * 30)
        
        return height
    }
    
    // TODO: Not working
    // 스와이프해서 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myVoteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: Handle Refresh Control
extension MyVoteViewController {
    
    private func configureRefreshControl() {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        // Update Content
        getMyVoteList()
        
        // Dismiss the refresh control
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: HTTP Request Method
extension MyVoteViewController {
    
    private func getMyVoteList() {
        let user = "1"
        let baseURL = "http://42votes.site/v1/questions/my/"
        let apiURL = URL(string: baseURL + user)!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                fatalError("nil found in data")
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                fatalError("response: \(String(describing: response))")
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            guard let output = try? decoder.decode([Question].self, from: data) else {
                print("data decode failed")
                return
            }
            
            DispatchQueue.main.async {
                self.myVoteList = output
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    private func getVoteData(from questionId: Int) {
        let questionId = String(questionId)
        let baseURL = "http://42votes.site/v1/questions/"
        let apiURL = URL(string: baseURL + questionId)!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                fatalError("nil found in data")
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                fatalError("response: \(String(describing: response))")
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            guard let decodedVoteData = try? decoder.decode(Vote.self, from: data) else {
                print("data decode failed")
                return
            }
            
            DispatchQueue.main.async {
                self.moveToVoteView(configureWith: decodedVoteData)
            }
            
        }.resume()
    }
    
    private func moveToVoteView(configureWith vote: Vote) {
        guard let voteVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteVC") as? VoteViewController else {
            return
        }
        voteVC.vote = vote
        self.navigationController?.pushViewController(voteVC, animated: true)
    }
}
