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
        questionLabel.text = voteData.question?.question
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
    // HomeViewController 에서 넘어옴
    var voteData: Vote!
    var allVotesCount = 0
    
    var lastTag = 0
    var contentHeight: CGFloat = 0
    
    // 버튼 누를 때마다 상태 변화 저장
    var isAnswerViewLoadedBefore = false
    var voteViewStatus = VoteViewStatus.beforeVote
    

    // MARK: - System Functions
    
    override func viewDidLoad() {
        // 뷰 초기 생성
        
        super.viewDidLoad()
        
        getAllVotesCount()
        configureScrollField()
        configureQuestionField()
        configureAnswerField()
        configureButtonField()
    }
    
    override func viewDidLayoutSubviews() {
        // 스크롤 하기 위해 contentSize 설정 필요
        // 각 UI 요소 만들어질 때마다 contentSize 증가함
        
        scrollView.contentSize.height = contentHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureAnswerField()
    }
    
    
    // MARK: - Not Complete
    // 공유 기능 추가해야 함.
    
    @IBAction func shareVote(_ sender: Any) {
        // share vote
        print("share button clicked")
    }
    
    
    // MARK: - Non View Configuration
    
    private func getAllVotesCount() {
        if let answers = voteData.answers {
            
            for answer in answers {
                allVotesCount += answer.count ?? 0
            }
        }
    }
    
    
    // MARK: - Configure Scroll Field
    
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
    
    
    // MARK: - Congifure Question Field
    
    private func configureQuestionField() {
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionStateLabel)
        
        if voteData.question?.isExpired == true {
            questionLabel.textColor = UIColor.lightGray
            questionStateLabel.text = "종료된 설문입니다."
            questionStateLabel.textColor = UIColor.lightGray
        }
        else if voteData.question?.isExpired == false {
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
    
    
    // MARK: - Configure Answer Field
    
    private func configureAnswerField() {
        
        if let answerList = voteData.answers {
            for elem in answerList {
                
                guard let id = elem.id else { return }
                guard let text = elem.answer else { return }
                guard let count = elem.count else { return }
                
                if isAnswerViewLoadedBefore {
                    if let answerView = contentView.viewWithTag(id) {
                        if let backLabel = answerView.viewWithTag(id + 100) {
                            
                            if voteViewStatus == .beforeVote {
                                backLabel.backgroundColor = UIColor.clear
                            } else if voteViewStatus == .afterVote || voteViewStatus == .checkResult {
                                backLabel.backgroundColor = UIColor.systemBrown
                            }
                        }
                    }
                    continue
                }
                
                // MARK: - Not Complete
                // 각 선택지 탭 했을 때, 해당 선택지 하이라이트되는 기능 추가해야 함.
                // 현 상태 : tap 먹히려면 answerView가 ContentView가 아닌 ScrollView의 subView가 되어야 함.
                // 바꿀 방법 1 : answerView를 ScrollView에 추가함
                // 바꿀 방법 2 : contentView를 투명화시킴
                let answerView: UIView = {
                    let answerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                    
                    answerView.tag = id
                    
                    answerView.isUserInteractionEnabled = true
                    answerView.addGestureRecognizer(tap)
                    answerView.translatesAutoresizingMaskIntoConstraints = false
                    return answerView
                }()
                
                let textLabel: UILabel = {
                    let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
                    
                    textLabel.tag = id
                    textLabel.text = "  " + text
                    
                    textLabel.translatesAutoresizingMaskIntoConstraints = false
                    return textLabel
                }()
                
                let backLabel: UILabel = {
                   let backLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
  
                    backLabel.tag = id + 100
                    
                    backLabel.translatesAutoresizingMaskIntoConstraints = false
                    return backLabel
                }()
                
                let baseWidth = (view.frame.width * 0.7) / CGFloat(allVotesCount)
                let widthCount = CGFloat((100 * count) / allVotesCount)
                
                setAnswerTextLabelAttribute(textLabel)
                setAnswerBackLabelAttribute(backLabel)
                
                answerView.addSubview(backLabel)
                answerView.addSubview(textLabel)
                contentView.addSubview(answerView)
                
                setAnswerViewConstraints(answerView)
                setAnswerConstraints(textLabel, backLabel, baseWidth * widthCount)
                lastTag += 1
            }
            
            isAnswerViewLoadedBefore = true
        }
    }
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        print("tapped")
    }
    
    private func setAnswerTextLabelAttribute(_ textLabel: UILabel) {
        textLabel.numberOfLines = 0
        textLabel.layer.borderWidth = 1.5
        textLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        if voteData.question?.isExpired == true {
            textLabel.textColor = UIColor.lightGray
            textLabel.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private func setAnswerBackLabelAttribute(_ backLabel: UILabel) {
        backLabel.numberOfLines = 0
        
        if voteData.question?.isExpired == true {
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
        
        if answerView.tag == 1 {
            answerView.topAnchor.constraint(equalTo: questionStateLabel.bottomAnchor, constant: 25).isActive = true
            self.contentHeight += (answerView.frame.height + 25)
        } else {
            guard let preAnswerView = contentView.viewWithTag(answerView.tag - 1) else { return }
            answerView.topAnchor.constraint(equalTo: preAnswerView.bottomAnchor, constant: 10).isActive = true
            self.contentHeight += (answerView.frame.height + 10)
        }
    }
    
    private func setAnswerConstraints(_ answer: UILabel, _ background: UILabel, _ backWidth: CGFloat) {
        answer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        answer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        answer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        background.leadingAnchor.constraint(equalTo: answer.leadingAnchor).isActive = true
        background.widthAnchor.constraint(equalToConstant: backWidth).isActive = true
        background.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if answer.tag == 1 {
            // 첫 번째 선택지일 때
            answer.topAnchor.constraint(equalTo: questionStateLabel.bottomAnchor, constant: 25).isActive = true
            background.topAnchor.constraint(equalTo: questionStateLabel.bottomAnchor, constant: 25).isActive = true
        } else {
            // 두 번째 선택지부터
            guard let preAnswer = contentView.viewWithTag(answer.tag - 1) else {
                fatalError("No preAnswer")
            }
            answer.topAnchor.constraint(equalTo: preAnswer.bottomAnchor, constant: 10).isActive = true
            background.topAnchor.constraint(equalTo: preAnswer.bottomAnchor, constant: 10).isActive = true
        }
    }
    
    
    // MARK: - Configure Button Field
    
    private func configureButtonField() {
        
        let voteAction = UIAction(handler: { _ in
            // 해당 answer의 count +1
            print("voteAction")
            
            self.voteViewStatus = .checkResult
            self.viewWillAppear(true)
        })
        
        let returnAction = UIAction(handler: { _ in
            // 결과 화면으로 바로 돌아가기
            print("returnAction")
            
            self.voteViewStatus = .checkResult
            self.viewWillAppear(true)
        })
        
        voteButton = UIButton(type: .system, primaryAction: voteAction)
        resultButton = UIButton(type: .system, primaryAction: returnAction)
        
        setButtonAttribute()
        
        // contentView의 subView로 넣으면 contentView에 가려져 터치가 먹지 않음.
        // contentView의 터치 동작을 무효화시켜봤는데 잘 안됨.
        // 그래서 contentView의 상위에 버튼 추가.
        
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
        guard let preComponent = contentView.viewWithTag(lastTag) else { return }
        
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
