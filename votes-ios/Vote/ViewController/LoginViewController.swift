//
//  LoginViewController.swift
//  Vote
//
//  Created by 권은빈 on 2022/01/04.
//

import UIKit
import Alamofire

// TODO: Show Alert when id or password is empty...

// TODO: Configure Constraints...

// TODO: Save Login Data in KeyChain or something else...
// TODO: Check if is Logined and set MyVoteView with that state...

class LoginViewController: UIViewController {
    
    private var login: Login!
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard let id = idField.text else {
            //alert
            return
        }
        guard let password = passwordField.text else {
            //alert
            return
        }
        
        // Make Data and Call API
        let userToLogin = User(password: password, username: id)
        let url = URLs.base.rawValue + URLs.login.rawValue
        
        AF.request(url,
                   method: .post,
                   parameters: userToLogin,
                   encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                switch response.result {
                case .success:
                    // TODO: Save Login Value in Keychain
                    if let data = response.value, let token = String(data: data, encoding: .utf8) {
                        self.login = Login(with: token, userToLogin)
                        self.moveToHomeView()
                    }
                case let .failure(error):
                    // TODO: Alert Error
                    print(error)
                }
        }
    }
    
    @IBAction func startWithoutLogin(_ sender: Any) {
        moveToHomeView()
    }
    
    private func moveToHomeView() {
        guard let homeView = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {
            fatalError("Cannot find storyboard with identifier TabBarController")
        }
        homeView.modalPresentationStyle = .fullScreen
        self.present(homeView, animated: true)
    }
}
