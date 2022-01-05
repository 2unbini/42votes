//
//  LoginViewController.swift
//  Vote
//
//  Created by 권은빈 on 2022/01/04.
//

import UIKit
import Alamofire

// TODO: Save Login Data in KeyChain or something else...
// TODO: Check if there's User Data and Skip Login View when is exist.

class LoginViewController: UIViewController {
    let hasUserData: Bool = UserDefaults.standard.bool(forKey: "hasUserData")
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hasUserData {
            let password = UserDefaults.standard.string(forKey: "password")
            let username = UserDefaults.standard.string(forKey: "username")
            loginAPICall(with: User(password: password, username: username))
        }
        self.idField.delegate = self
        self.passwordField.delegate = self
    }
    
    @IBAction func login(_ sender: Any) {
        guard
            let id = idField.text,
            let password = passwordField.text
        else {
            fatalError("Textfield.text == nil")
        }
        
        if id.isEmpty || password.isEmpty {
            alertOccurred(message: textFieldisEmpty, handler: nil)
            return
        }
        
        // Make Data
        let userToLogin = User(password: password, username: id)
        
        // Clean Fields
        idField.text = ""
        passwordField.text = ""
        
        // Login API Call
        loginAPICall(with: userToLogin)
    }
    
    private func loginAPICall(with user: User) {
        let url = URLs.base.rawValue + URLs.login.rawValue
        
        AF.request(url,
                   method: .post,
                   parameters: user,
                   encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                switch response.result {
                case .success:
                    // TODO: Save Login Value in Keychain
                    if let data = response.value, let token = String(data: data, encoding: .utf8) {
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        UserDefaults.standard.setValue(user.password, forKey: "password")
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "hasUserData")
                        self.moveToHomeView()
                    }
                case let .failure(error):
                    self.alertOccurred(message: loginFailed + "\nError: \(error)", handler: nil)
                    print(error)
                }
        }
    }
    
    @IBAction func startWithoutLogin(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "hasUserData")
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
