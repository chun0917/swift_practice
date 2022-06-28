//
//  UIViewControllerExtension.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/6/1.
//

import Foundation
import UIKit
import Combine

extension UIViewController{
    
    func showAlert(title: String,
                   message: String,
                   handler: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: handler)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
