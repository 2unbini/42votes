//
//  VoteViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/12/03.
//

import UIKit

class VoteViewController: UIViewController {
    
    // MARK: - View Properties
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var questionLabel: UILabel = {
        let questionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height * 0.2))
        
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.text = vote.question?.question
        questionLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        return questionLabel
    }()
    
    lazy var questionStateLabel: UILabel = {
        let questionStateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: questionLabel.frame.height * 0.5))
        
        questionStateLabel.textAlignment = .center
        questionStateLabel.font = .systemFont(ofSize: 15)
        
        questionStateLabel.translatesAutoresizingMaskIntoConstraints = false
        return questionStateLabel
    }()
    
    var voteButton: UIButton!
    var resultButton: UIButton!
    
    
    // MARK: - Variables
    var vote: Vote!
    var allVotesCount: Int = 0
    
    var answerTag: Int = VoteViewTag.startAnswer.rawValue
    var loadTag: Int = 1
    var contentHeight: CGFloat = 0
    
    // 버튼 누를 때마다 상태 변화 저장
    var selectedAnswerTag: Int = VoteViewTag.invalid.rawValue
    var isAnswerViewLoadedBefore: Bool = false
    var voteViewStatus: VoteViewStatus = .beforeVote

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vote.question?.isExpired == true {
            voteViewStatus = .expiredVote
        }
        getAllVotesCount()
        configureScrollField()
        configureQuestionField()
        configureAnswerField()
        configureButtonField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: 새로 계산된 값으로 AnswerField configure 필요
    }
    
    override func viewDidLayoutSubviews() {
        // 스크롤 하기 위해 contentSize 설정 필요
        // 각 UI 요소 만들어질 때마다 contentSize 증가함
        
        scrollView.contentSize.height = contentHeight
    }
    
    // TODO: 공유 기능
    @IBAction func shareVote(_ sender: Any) {
        // share vote
        print("share button clicked")
    }
    
    private func getAllVotesCount() {
        if let answers = vote.answers {
            
            for answer in answers {
                allVotesCount += answer.count ?? 0
            }
        }
    }
}

// MARK: - Configure Scroll Field
extension VoteViewController {
    
    private func configureScrollField() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        setScrollViewConstraints()
    }
    
    private func setScrollViewConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

// MARK: - Congifure Question Field
extension VoteViewController {
    
    private func configureQuestionField() {
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionStateLabel)
        
        if vote.question?.isExpired == true {
            questionLabel.textColor = UIColor.lightGray
            questionStateLabel.text = "종료된 설문입니다."
            questionStateLabel.textColor = UIColor.lightGray
        }
        else if vote.question?.isExpired == false {
            // TODO: 시간 계산해서 카운트다운
            questionStateLabel.text = "진행중인 설문입니다."
        }
        
        setQuestionLabelConstraints()
        setQuestionStateLabelConstraints()
    }
    
    private func setQuestionLabelConstraints() {
        questionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        questionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 25).isActive = true
        questionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true

        self.contentHeight += (questionLabel.frame.height + 25)
    }
    
    private func setQuestionStateLabelConstraints() {
        questionStateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        questionStateLabel.topAnchor.constraint(equalTo: self.questionLabel.bottomAnchor, constant: 15).isActive = true
        questionStateLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        
        self.contentHeight += (questionStateLabel.frame.height + 15)
    }
}

// MARK: - Configure Answer Field
extension VoteViewController {
    
    private func configureAnswerField() {
        
        if let answerList = vote.answers {
            for elem in answerList {
                
                guard let text = elem.answer else { return }
                guard let count = elem.count else { return }
                
                let answerView: UIView = {
                    let answerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction(sender:)))

                    answerView.tag = answerTag
                    answerView.isUserInteractionEnabled = true
                    answerView.addGestureRecognizer(tap)
                    answerView.translatesAutoresizingMaskIntoConstraints = false
                    return answerView
                }()
                
                let textLabel: UILabel = {
                    let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
                    
                    textLabel.text = "  " + text
                    
                    textLabel.translatesAutoresizingMaskIntoConstraints = false
                    return textLabel
                }()
                
                let resultBar: UILabel = {
                    let resultBar = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
                    
                    resultBar.tag = answerTag + VoteViewTag.background.rawValue

                    resultBar.translatesAutoresizingMaskIntoConstraints = false
                    return resultBar
                }()
                
                let selectedBack: UILabel = {
                    let selectedBack = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
                    
                    selectedBack.tag = answerTag + VoteViewTag.selected.rawValue
                    
                    selectedBack.translatesAutoresizingMaskIntoConstraints = false
                    return selectedBack
                }()
                
                let percent = allVotesCount == 0 ? 0 : CGFloat((Float(count) / Float(allVotesCount)))
                
                setAnswerTextLabelAttribute(textLabel)
                setAnswerResultBarAttribute(resultBar)
                
                answerView.addSubview(selectedBack)
                answerView.addSubview(resultBar)
                answerView.addSubview(textLabel)
                scrollView.addSubview(answerView)
                
                setAnswerViewConstraints(answerView)
                setAnswerConstraints(answerView, [textLabel, resultBar, selectedBack], percent)
                answerTag += 1
            }
            
            answerTag -= 1
            isAnswerViewLoadedBefore = true
        }
    }
    
    // 탭 한 경우, 해당 부분의 색상 다르게 보이는 기능 추가
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        
        if voteViewStatus != .beforeVote {
            print("Tap Answer Locked")
            return
        }
        
        guard let parentView = sender.view else { fatalError("No parent View") }
        guard let childBackgroundView = parentView.viewWithTag(parentView.tag + VoteViewTag.selected.rawValue) else { fatalError("No child Background View") }
        
        if selectedAnswerTag != VoteViewTag.invalid.rawValue && childBackgroundView.tag != selectedAnswerTag {
            guard let preSelectedAnswerView = scrollView.viewWithTag(selectedAnswerTag) else { fatalError("No previous selected Answer View") }
            preSelectedAnswerView.backgroundColor = .clear
        }
        
        childBackgroundView.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        selectedAnswerTag = childBackgroundView.tag
        viewWillAppear(true)
    }
    
    private func configureAnswerFieldAfterVote() {
        if isAnswerViewLoadedBefore && answerTag != 1 {
            for _ in 1...(answerTag) {
                if let answerView = scrollView.viewWithTag(loadTag) {
                    if let backLabel = answerView.viewWithTag(loadTag + VoteViewTag.background.rawValue) {
                        
                        if voteViewStatus == .beforeVote {
                            backLabel.backgroundColor = UIColor.clear
                        } else if voteViewStatus == .afterVote || voteViewStatus == .checkResult {
                            backLabel.backgroundColor = UIColor.systemGray2
                        }
                    }
                }
                loadTag += 1
                continue
            }
            loadTag = 1
            return
        }
    }
    
    private func setAnswerTextLabelAttribute(_ textLabel: UILabel) {
        textLabel.numberOfLines = 0
        textLabel.layer.borderWidth = 1.5
        textLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        if vote.question?.isExpired == true {
            textLabel.textColor = UIColor.lightGray
            textLabel.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private func setAnswerResultBarAttribute(_ backLabel: UILabel) {
        backLabel.numberOfLines = 0
        
        if vote.question?.isExpired == true {
            backLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        } else {
            if voteViewStatus == .beforeVote {
                backLabel.backgroundColor = UIColor.clear
            } else {
                backLabel.backgroundColor = UIColor.systemBrown
            }
        }
    }
    
    private func setAnswerViewConstraints(_ answerView: UIView) {
        answerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        answerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        answerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if answerView.tag == VoteViewTag.startAnswer.rawValue {
            answerView.topAnchor.constraint(equalTo: questionStateLabel.bottomAnchor, constant: 25).isActive = true
            self.contentHeight += (answerView.frame.height + 25)
        } else {
            guard let preAnswerView = scrollView.viewWithTag(answerView.tag - 1) else { return }
            answerView.topAnchor.constraint(equalTo: preAnswerView.bottomAnchor, constant: 10).isActive = true
            self.contentHeight += (answerView.frame.height + 10)
        }
    }
    
    private func setAnswerConstraints(_ parentView: UIView, _ childViews: [UILabel], _ percent: CGFloat) {
        let answer = childViews[0]
        let background = childViews[1]
        let selected = childViews[2]
        
        answer.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        answer.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        answer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        answer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        background.leadingAnchor.constraint(equalTo: answer.leadingAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        background.widthAnchor.constraint(equalTo: answer.widthAnchor, multiplier: percent).isActive = true
        background.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        selected.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        selected.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        selected.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        selected.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

// MARK: - Configure Button Field

extension UIButton {
    func disable() {
        self.isEnabled = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setTitleColor(.lightGray, for: .normal)
    }
}

extension VoteViewController {
    
    private func configureButtonField() {
        
        // TODO: 버튼 눌렀을 때 새로 count된 값 계산해서 뷰로 생성
        let voteAction = UIAction(handler: { _ in
            // TODO: 해당 answer의 count +1
            self.sendUserVote()
        })
        
        let returnAction = UIAction(handler: { _ in
            self.voteViewStatus = .checkResult
            self.configureAnswerFieldAfterVote()
            self.viewWillAppear(true)
        })
        
        voteButton = UIButton(type: .system, primaryAction: voteAction)
        resultButton = UIButton(type: .system, primaryAction: returnAction)
        
        setButtonAttribute()
        
        if vote.question?.isExpired == true {
            voteButton.disable()
            resultButton.disable()
        }
      
        scrollView.addSubview(voteButton)
        scrollView.addSubview(resultButton)
        
        setButtonConstraint()
    }
    
    private func setButtonAttribute() {
        
        voteButton.layer.borderWidth = 1.0
        voteButton.layer.borderColor = UIColor.black.cgColor
        voteButton.setTitle("투표하기", for: .normal)
        voteButton.setTitleColor(.black, for: .normal)
        
        resultButton.layer.borderWidth = 1.0
        resultButton.layer.borderColor = UIColor.black.cgColor
        resultButton.setTitle("결과보기", for: .normal)
        resultButton.setTitleColor(.black, for: .normal)
        
        voteButton.translatesAutoresizingMaskIntoConstraints = false
        resultButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setButtonConstraint() {
        guard let preComponent = scrollView.viewWithTag(answerTag) else { return }
        
        voteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -60).isActive = true
        resultButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 60).isActive = true
        
        voteButton.topAnchor.constraint(equalTo: preComponent.bottomAnchor, constant: 20).isActive = true
        resultButton.topAnchor.constraint(equalTo: preComponent.bottomAnchor, constant: 20).isActive = true
        
        voteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.22).isActive = true
        voteButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        resultButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.22).isActive = true
        resultButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.contentHeight += (voteButton.frame.height + 20)
    }
}

// MARK: HTTP Request Method
extension VoteViewController {
    private func sendUserVote() {
        // Configure userVote
        let userVote = UserVote()
        
        let selectedAnswerIndex = selectedAnswerTag - VoteViewTag.selected.rawValue - 1
        if selectedAnswerIndex < 0 {
            return
        }
        userVote.questionId = vote.question?.id
        userVote.answerId = vote.answers![selectedAnswerIndex].id
        
        // Encode Data
        let encoder = JSONEncoder()
        let encodedVote = try? encoder.encode(userVote)
        
        // Configure url and request
        let userId = "1"
        let url: URL! = URL(string: URLs.base.rawValue + URLs.answer.rawValue + userId)
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedVote
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                fatalError("nil found in data")
            }
            
            guard let response = response else {
                fatalError("response: \(String(describing: response))")
            }
            
            print(response)
            
            DispatchQueue.main.async {
                // TODO: 일단 유저가 투표 했었는지 안했는지 체크
                // 했으면 alert 띄우기, 안했으면 아래 내용 유지
                self.voteViewStatus = .checkResult
                self.configureAnswerFieldAfterVote()
                self.viewWillAppear(true)
            }
            
        }.resume()
    }
}
