//
//  MyVoteViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import UIKit

class MyVoteViewController: UITableViewController {
    
    var myVoteList = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        getMyVoteList()
    }
    
    // MARK: - Refresh
    
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
    
    private func getMyVoteList() {
        let user = "1"
        let baseURL = "http://42votes.site/v1/questions/my/"
        let apiURL = URL(string: baseURL + user)!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myVoteList.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row) selected...")
        
        guard let voteVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteVC") as? VoteViewController else {
            return
        }
        
        voteVC.questionId = myVoteList[indexPath.row].id
        self.navigationController?.pushViewController(voteVC, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.myVoteList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteList", for: indexPath)
        let label = cell.viewWithTag(Tag.voteList.rawValue) as? UILabel
        let labelText = "Q. " + (row.question ?? "")
        
        label?.numberOfLines = 0
        
        // Clear Attributes of label text
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

