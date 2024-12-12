//
//  UIViewController + Extension.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 08.12.2024.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String? = nil, actionTitle: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
