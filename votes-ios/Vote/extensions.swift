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

extension UIViewController {
    func alertAccured(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
