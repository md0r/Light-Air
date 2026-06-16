//
//  UIAlert + Extensions.swift
//  Light Air
//
//  Created by Mihai on 09/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func showCustomAlert(title: String, message: String,  buttonMessage: String,  vc: UIViewController) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertAction.Style.default, handler: nil))
       vc.present(alert, animated: true, completion: nil)
    }
    
}
