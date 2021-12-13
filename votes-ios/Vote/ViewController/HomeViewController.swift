//
//  HomeViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var list = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestionList()
    }
    
    
    // MARK: - HTTP
    
    private func getQuestionList() {
        let url = "http://42votes.site/v1/questions/all"

        let apiURI: URL! = URL(string: url)
        
        var request = URLRequest(url: apiURI)
        
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
            
            guard let output = try? decoder.decode([Question].self, from: data) else {
                print(error?.localizedDescription)
                return
            }
            
            print(output)
            
            DispatchQueue.main.async {
                self.list = output
                self.tableView.reloadData()
            }
            
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row) selected...")
        
        guard let voteVC = self.storyboard?.instantiateViewController(withIdentifier: "VoteVC") as? VoteViewController else {
            return
        }
        
        voteVC.questionId = list[indexPath.row].id
        self.navigationController?.pushViewController(voteVC, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteList", for: indexPath)
        let label = cell.viewWithTag(Tag.voteList.rawValue) as? UILabel
        let labelText = "Q. " + (row.question ?? "")
        
        label?.numberOfLines = 0
        
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
        let row = self.list[indexPath.row]
        let height = CGFloat(50 + (row.question!.count / 25) * 30)
        
        return height
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
