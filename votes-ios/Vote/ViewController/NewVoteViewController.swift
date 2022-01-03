//
//  NewVoteViewController.swift
//  Vote
//
//  Created by 권은빈 on 2021/11/30.
//
// MARK: -- NEED TO IMPLEMENT
// 1. 선택지 늘릴 때 버튼의 위치 constant로 조정하는 것 말고 다른 방식은?
// -> 문제점) 정확한 값X 조금씩 밀림
// 2. ScrollView 밑에 잘리는 현상 해결 필요
// -> 문제점) contentView heigth 계산 로직이 이상함

// MARK: - tags
// Tag.swift


import UIKit

class NewVoteViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    
    private var viewIndex = Tag.questionLabel.rawValue
    private var buttonIndex = Tag.addButton.rawValue
    
    private var contentViewHeight: CGFloat = 0
    
    private var isViewAfterButton = false
    private var answerIndexArray = [Int]()
    
    private var buttonViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureQuestionField()
        configureAnswerField()
        configureButton()
        configureDateField()
    }
    
    override func viewDidLayoutSubviews() {
        guard let scrollView = view.viewWithTag(Tag.scrollView.rawValue) as? UIScrollView else { fatalError("Cannot find ScrollView with tag \(Tag.scrollView.rawValue)")}
        
        scrollView.contentSize.height = contentViewHeight
    }
    
    // 새 투표 저장한 뒤 이전 화면으로 돌아가기
    @IBAction func saveNewVote() {
        
        if let newVote = makeNewVote() {
            let encodedData = encodeData(with: newVote)
            postNewVote(with: encodedData)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - UITextView extension
// 플레이스홀더 사용, 리턴키 클릭시 키보드 없애는 기능을 위한 extension
extension NewVoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var placeholder: String
        
        if textView.tag == 3 {
            placeholder = "질문을 입력하세요."
        } else {
            placeholder = "선택지를 입력하세요."
        }
        
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: Post New Vote

extension NewVoteViewController {
    private func makeNewVote() -> NewVote? {
        let newVote = NewVote()
        let question = self.contentView.viewWithTag(Tag.questionTextView.rawValue) as? UITextView
        let date = self.contentView.viewWithTag(Tag.dueDatePicker.rawValue) as? UIDatePicker
        
        newVote.question = question?.text
        newVote.answers = [String]()
        newVote.expiresAt = date?.date
        
        if question?.textColor == UIColor.lightGray || question?.text == "" {
            alertOccurred(message: "질문을 입력하세요.")
            return nil
        }
        
        for i in answerIndexArray {
            guard let answerView = self.contentView.viewWithTag(i) as? UITextView else { fatalError("No AnswerView with tag \(i) Found") }
            
            if answerView.textColor == UIColor.lightGray || answerView.text == "" {
                alertOccurred(message: "선택지를 입력하세요.")
                return nil
            }
            newVote.answers?.append(answerView.text)
        }
        
        if date!.date <= Date() {
            alertOccurred(message: "투표 종료 날짜가 유효하지 않습니다.")
            return nil
        }
        
        return newVote
    }
    
    private func encodeData(with newVote: NewVote) -> Data {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        var encodedData: Data
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        do {
            encodedData = try encoder.encode(newVote)
        }
        catch {
            fatalError("Cannot encode Data")
        }
        
        return encodedData
    }
    
    private func postNewVote(with data: Data) {
        let baseURL = "http://42votes.site/v1/questions/my/"
        let userId = "1"
        let apiURI: URL! = URL(string: baseURL + userId)
        
        var request = URLRequest(url: apiURI)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                fatalError("nil found in data")
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                fatalError("response: \(String(describing: response))")
            }
            
        }.resume()
    }
}

// MARK: Set Constraint and Attribute to Label and Text

extension NewVoteViewController {
    private func setLabelConstraint(_ tag: Int) {
        
        var heightConstant: CGFloat = 0
        let preIndex = tag - 1
        
        if let label = contentView.viewWithTag(tag) {
            
            // contstraints 코드로 설정하기
            label.translatesAutoresizingMaskIntoConstraints = false
            
            // leading constraint
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
            
            // 조건에 따라 top constraint
            if tag == Tag.questionLabel.rawValue {
                label.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: 30).isActive = true
                heightConstant = 30
            } else if tag == Tag.answerLabel.rawValue {
                label.topAnchor.constraint(equalTo: contentView.viewWithTag(preIndex)!.bottomAnchor,
                                           constant: 30).isActive = true
                heightConstant = 30
            } else if tag == Tag.dueDateLabel.rawValue {
                label.topAnchor.constraint(equalTo: contentView.viewWithTag(201)!.bottomAnchor,
                                           constant: 30).isActive = true
                heightConstant = 30
            } else {
                label.topAnchor.constraint(equalTo: contentView.viewWithTag(preIndex)!.bottomAnchor,
                                           constant: 20).isActive = true
                heightConstant = 20
            }
            
            self.contentViewHeight += heightConstant
        }
    }
    
    private func setTextViewConstraint(_ tag: Int) {
        
        var heightConstant: CGFloat = 0
        
        if let textView = contentView.viewWithTag(tag) {
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,
                                              constant: 0).isActive = true
            textView.topAnchor.constraint(equalTo: contentView.viewWithTag(tag - 1)!.bottomAnchor,
                                          constant: 10).isActive = true
            
            if tag == Tag.questionTextView.rawValue {
                textView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                multiplier: 0.8).isActive = true
                textView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                 multiplier: 0.1).isActive = true
                heightConstant = (contentView.frame.height) * 0.1
            } else {
                textView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                multiplier: 0.8).isActive = true
                textView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                 multiplier: 0.05).isActive = true
                heightConstant = (contentView.frame.height) * 0.05
            }
            
            self.contentViewHeight += (10 + heightConstant)
        }
    }
    
    private func setLabelAttribute(labelText: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        label.text = labelText
        label.font = .systemFont(ofSize: 19, weight: .bold)
        
        if isViewAfterButton {
            label.tag = buttonIndex
            buttonIndex += 1
        } else {
            label.tag = viewIndex
            viewIndex += 1
        }
        
        self.contentViewHeight += 30
        return label
    }
    
    private func setLightLabelAttribute(labelText: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width * 0.9, height: 30))
        
        label.text = labelText
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        if isViewAfterButton {
            label.tag = buttonIndex
            buttonIndex += 1
        } else {
            label.tag = viewIndex
            viewIndex += 1
        }
        
        self.contentViewHeight += 30
        return label
    }
    
    private func setTextViewAttribute(placeholder: String) -> UITextView {
        let textView = UITextView()
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        textView.textColor = UIColor.lightGray
        textView.text = placeholder
        textView.font = .systemFont(ofSize: 17)
        textView.tag = viewIndex
        viewIndex += 1
        
        return textView
    }
}

// MARK: Configure Question Field

extension NewVoteViewController {
    private func configureQuestionField() {
        let questionLabel = setLabelAttribute(labelText: "질문")
        let questionTextView = setTextViewAttribute(placeholder: "질문을 입력하세요.")
        
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionTextView)
        
        questionTextView.delegate = self
        
        setLabelConstraint(questionLabel.tag)
        setTextViewConstraint(questionTextView.tag)
    }
}


// MARK: Configure Answer Field

extension NewVoteViewController {
    private func configureAnswerField() {
        let answerLabel = setLabelAttribute(labelText: "선택지")
        let defaultAnswerOne = setTextViewAttribute(placeholder: "선택지를 입력하세요.")
        let defaultAnswerTwo = setTextViewAttribute(placeholder: "선택지를 입력하세요.")
        
        contentView.addSubview(answerLabel)
        contentView.addSubview(defaultAnswerOne)
        contentView.addSubview(defaultAnswerTwo)
        
        defaultAnswerOne.delegate = self
        defaultAnswerTwo.delegate = self
        answerIndexArray.append(defaultAnswerOne.tag)
        answerIndexArray.append(defaultAnswerTwo.tag)
        
        setLabelConstraint(answerLabel.tag)
        setTextViewConstraint(defaultAnswerOne.tag)
        setTextViewConstraint(defaultAnswerTwo.tag)
    }
}

// MARK: Configure Button Field

extension NewVoteViewController {
    private func configureButton() {
        let buttonView = UIView()
        let addButton = setButtonAttribute(action: "add")
        let deleteButton = setButtonAttribute(action: "delete")
        
        buttonView.addSubview(addButton)
        buttonView.addSubview(deleteButton)
        contentView.addSubview(buttonView)
        
        setButtonViewConstraint(buttonView)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor,
                                        constant: -20).isActive = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor,
                                        constant: 20).isActive = true
        
        self.isViewAfterButton = true
    }
    
    private func setButtonViewConstraint(_ buttonView: UIView) {
        
        guard let lastAnswerView = contentView.viewWithTag(viewIndex - 1) else { fatalError("Cannot load Last View with tag \(viewIndex - 1)") }
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        self.buttonViewConstraint = buttonView.topAnchor.constraint(equalTo: lastAnswerView.bottomAnchor, constant: 20)
        self.buttonViewConstraint.isActive = true
        buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.contentViewHeight += 50
    }
    
    private func setButtonAttribute(action: String) -> UIButton {
        
        let add = UIAction(handler: {_ in
            if self.answerIndexArray.count < 10 {
                let newAnswerField = self.setTextViewAttribute(placeholder: "선택지를 입력하세요.")
                self.answerIndexArray.append(newAnswerField.tag)
                
                newAnswerField.delegate = self
                self.contentView.addSubview(newAnswerField)
                self.setTextViewConstraint(newAnswerField.tag)
                
                self.buttonViewConstraint.constant += 49
                self.contentViewHeight += 49
                self.view.layoutIfNeeded()
            }
        })
        
        let delete = UIAction(handler: {_ in
            if self.answerIndexArray.count > 2 {
                if let removeAnswer = self.view.viewWithTag(self.viewIndex - 1) {
                    print(self.viewIndex - 1)
                    removeAnswer.removeFromSuperview()
                    self.answerIndexArray.removeLast()
                    self.viewIndex -= 1
                    
                    self.buttonViewConstraint.constant -= 49
                    self.contentViewHeight -= 49
                    self.view.layoutIfNeeded()
                }
            }
        })
        
        let imageName = (action == "add") ? "plus.circle" : "minus.circle"
        let button = UIButton(type: .system, primaryAction: action == "add" ? add : delete)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tag = buttonIndex
        
        buttonIndex += 1
        
        return button
    }
}

// MARK: Configure DatePicker Field

extension NewVoteViewController {
    private func configureDateField() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm EEEE"
        
        let dueDateLabel = setLabelAttribute(labelText: "투표 종료 날짜")
        let dateLabel = setLightLabelAttribute(labelText: dateFormatter.string(from: currentDate))
        let dueDatePicker = setDatePickerAttribute()
        
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dueDatePicker)
        
        setLabelConstraint(dueDateLabel.tag)
        setLabelConstraint(dateLabel.tag)
        setDatePickerConstraint(dueDatePicker.tag)
    }
    
    func setDatePickerConstraint(_ tag: Int) {
        if let datePicker = contentView.viewWithTag(tag) {
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            
            datePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,
                                                constant: 0).isActive = true
            datePicker.topAnchor.constraint(equalTo: contentView.viewWithTag(tag - 1)!.bottomAnchor,
                                            constant: 20).isActive = true
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor,
                                              multiplier: 0.8).isActive = true
            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor,
                                               multiplier: 0.2).isActive = true
            self.contentViewHeight += (20 + view.frame.height * 0.2)
        }
    }
    
    private func setDatePickerAttribute() -> UIDatePicker {
        let datePicker = UIDatePicker()
        
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        datePicker.tag = buttonIndex
        buttonIndex += 1
        
        return datePicker
    }
    
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm EEEE"
        
        if let label = contentView.viewWithTag(Tag.dateLabel.rawValue) as? UILabel {
            label.text = dateFormatter.string(from: sender.date as Date)
        }
    }
}
