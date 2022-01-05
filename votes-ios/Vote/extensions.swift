//
//  functions.swift
//  Vote
//
//  Created by 권은빈 on 2021/12/28.
//

import UIKit

extension UIButton {
    func disable() {
        self.isEnabled = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setTitleColor(.lightGray, for: .normal)
    }
}

/*
 MARK: Error
 2022-01-05 20:16:04.567379+0900 Vote[35309:10675562] [Presentation] Attempt to present <UIAlertController: 0x15a896400> on <UINavigationController: 0x15c825200> (from <Vote.SigninViewController: 0x15b60ab60>) which is already presenting <UIAlertController: 0x15c826e00>.
 */
extension UIViewController {
    func alertOccurred(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// return 입력 시 키보드 사라지는 것.
// 델리게이트 패턴 사용.
// MARK: viewDidLoad()에 delegate 지정 해 줘야 함.
extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
