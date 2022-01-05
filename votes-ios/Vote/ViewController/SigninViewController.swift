//
//  SigninViewController.swift
//  Vote
//
//  Created by 권은빈 on 2022/01/04.
//

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var idField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
    }
    
    private func setTextFieldDelegate() {
        self.emailField.delegate = self
        self.idField.delegate = self
        self.passwordField.delegate = self
        self.passwordConfirmField.delegate = self
    }
    
    @IBAction func quitSignIn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        let newUser = configureForm()
        let url = URLs.base.rawValue + URLs.register.rawValue
        
        AF.request(url,
                   method: .post,
                   parameters: newUser,
                   encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    // TODO: Dismiss Modal View After Alert
                    self.dismiss(animated: true)
                case let .failure(error):
                    self.alertOccurred(message: failedSignIn)
                    print(error)
                }
            }
    }
    
    private func configureForm() -> NewUser? {
        guard
            let email = emailField.text,
            let id = idField.text,
            let password = passwordField.text,
            let confirmedPassword = passwordConfirmField.text
        else {
            fatalError("Textfield.text == nil")
        }
        
        if email.isEmpty || id.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
            alertOccurred(message: textFieldisEmpty)
            return nil
        }
        
        if password != confirmedPassword {
            alertOccurred(message: passwordNotConfirmed)
            return nil
        }
        
        return NewUser(email: email, password: password, username: id)
    }
}
