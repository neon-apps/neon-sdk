//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

class AlertManager{
    
    static func showCustomAlert(title: String, message: String, style : UIAlertController.Style, buttons : [AlertButton]? = nil ,viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
 
        if let buttons, !buttons.isEmpty{
            for button in buttons {
                alert.addAction(UIAlertAction(title: button.title, style: button.style, handler: {_ in
                    button.completion()
                }))
            }
        }else{
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

