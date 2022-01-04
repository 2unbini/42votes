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
                    // TODO: Alert when call failed
                    print(error)
                }
            }
    }
    
    private func configureForm() -> NewUser? {
        guard let email = emailField.text else {
            //alert
            return nil
        }
        guard let id = idField.text else {
            //alert
            return nil
        }
        guard let password = passwordField.text else {
            //alert
            return nil
        }
        
        return NewUser(email: email, password: password, username: id)
    }
}
