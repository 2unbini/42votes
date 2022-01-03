//
//  HomeViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var allVoteList = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        getAllVoteList()
    }
    
    // 테이블뷰를 구성하는 데이터가 몇 행인지 리턴
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allVoteList.count
    }
    
    // 행 선택시, 선택한 투표 데이터 서버로부터 받아오고 VoteView로 이동
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let questionId = allVoteList[indexPath.row].id else { fatalError("nil found in questionId") }
        getVoteData(from: questionId)
    }

    // 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.allVoteList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteList", for: indexPath)
        let label = cell.viewWithTag(Tag.voteList.rawValue) as? UILabel
        let labelText = "Q. " + (row.question ?? "")

        label?.numberOfLines = 0
        
        // 라벨의 속성 초기화
        label?.textColor = UIColor.black
        label?.attributedText = NSAttributedString(string: "")
        
        if row.isExpired == false {
            label?.text = labelText
        } else if row.isExpired == true {
            label?.textColor = UIColor.lightGray
            label?.attributedText = labelText.strikeThrough()
        }
        
        return cell
    }
    
    // 각 행의 높이 지정
    // 글자 수가 일정 개수 이상이면 연산을 통해 높이 늘리기
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = self.allVoteList[indexPath.row]
        let height = CGFloat(50 + (row.question!.count / 25) * 30)
        
        return height
    }
}

// MARK: Handle Refresh Control
extension HomeViewController {
    
    func configureRefreshControl() {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        // Update Content
        getAllVoteList()
        
        // Dismiss the refresh control
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: HTTP Request Method
extension HomeViewController {
    
    private func getAllVoteList() {
        let baseURL = "http://42votes.site/v1/questions/all"
        let apiURI: URL! = URL(string: baseURL)
        
        var request = URLRequest(url: apiURI)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                fatalError("nil found in data")
            }
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("response: \(String(describing: response))")
            }
            
            if (200 ... 299) ~= response.statusCode {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                guard let output = try? decoder.decode([Question].self, from: data) else {
                    print("data decode failed")
                    return
                }
                
                DispatchQueue.main.async {
                    self.allVoteList = output
                    self.tableView.reloadData()
                }
            }
            
            if (400 ... 499) ~= response.statusCode {
                DispatchQueue.main.async {
                    self.alertOccurred(message: "다시 시도해주십시오.")
                }
            }
            
            if (500 ... 599) ~= response.statusCode {
                DispatchQueue.main.async {
                    self.alertOccurred(message: "서버 오류입니다.")
                }
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
            
            guard let response = response as? HTTPURLResponse else {
                fatalError("response: \(String(describing: response))")
            }
            
            if (200 ... 299) ~= response.statusCode {
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
            }
            
            if (400 ... 499) ~= response.statusCode {
                DispatchQueue.main.async {
                    self.alertOccurred(message: "다시 시도해주십시오.")
                }
            }
            
            if (500 ... 599) ~= response.statusCode {
                DispatchQueue.main.async {
                    self.alertOccurred(message: "서버 오류입니다.")
                }
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

// 취소선을 위한 익스텐션
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}
