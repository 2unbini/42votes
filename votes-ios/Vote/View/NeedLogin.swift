//
//  NeedLogin.swift
//  Vote
//
//  Created by 권은빈 on 2022/01/05.
//

import UIKit

class NeedLoginView: UIView {

    var describeLabel: UILabel!
    var button: UIButton!
    var parentVC: UIViewController!
    
    init(frame: CGRect, _ parentVC: UIViewController) {
        super.init(frame: frame)
        self.parentVC = parentVC
        self.initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initializeView() {
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        configureLabel()
        configureButton()
        self.addSubview(describeLabel)
        self.addSubview(button)
        configureChildConstraints()
    }
    
    private func configureLabel() {
        self.describeLabel = UILabel(frame: CGRect())
        self.describeLabel.text = loginNeededDescription
        self.describeLabel.textAlignment = .center
        self.describeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureButton() {
        self.button = UIButton(frame: CGRect())
        self.button.layer.cornerRadius = 10
        self.button.backgroundColor = .gray
        self.button.setTitle(loginNeededButtonTitle, for: .normal)
        self.button.titleLabel?.font = .systemFont(ofSize: 15)
        self.button.addTarget(self, action: #selector(moveToLoginView), for: .touchUpInside)
        self.button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func moveToLoginView(_ sender: Any) {
        self.parentVC.dismiss(animated: true)
    }
    
    private func configureChildConstraints() {
        self.describeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.describeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.describeLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.describeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.button.topAnchor.constraint(equalTo: describeLabel.bottomAnchor, constant: 20).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureConstraints(_ parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    }
}
