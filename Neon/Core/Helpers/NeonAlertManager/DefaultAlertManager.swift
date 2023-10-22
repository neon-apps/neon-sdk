//
//  File.swift
//
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit





@available(iOS 13.0, *)
public class DefaultAlertManager{
    
    public static func present(title: String?, message: String?, style : UIAlertController.Style, buttons : [AlertButton]? = nil ,viewController: UIViewController, overrideUserInterfaceStyle : UIUserInterfaceStyle = .unspecified) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.overrideUserInterfaceStyle = overrideUserInterfaceStyle
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
    
    
    private static var alertController: UIAlertController?
    
    public static func presentLoadingAlert(
        title: String = "",
        message: String = "",
        viewController: UIViewController,
        height : CGFloat = 130
    ) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let spinner = UIActivityIndicatorView(style: .medium)
        alertController?.view.addSubview(spinner)
        
        viewController.present(alertController!, animated: true, completion: nil)
        
        spinner.snp.makeConstraints { make in
            make.bottom.equalTo(alertController!.view).inset(20) // Adjust the top constraint
            make.centerX.equalTo(alertController!.view)
        }
        alertController?.view.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        spinner.startAnimating()
    }
    
    public static func updateLoadingAlert(title: String? = nil, message: String? = nil) {
      
        if let title{
            alertController?.title = title
        }
        
        if let message{
            alertController?.message = message
        }
      
    }
    
    public static func dismissLoadingAlert() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    
    @available(*, unavailable, renamed: "present")
    public static func showCustomAlert(title: String?, message: String?, style : UIAlertController.Style, buttons : [AlertButton]? = nil ,viewController: UIViewController, overrideUserInterfaceStyle : UIUserInterfaceStyle = .unspecified) {}
    
    @available(*, unavailable, renamed: "presentLoadingAlert")
    public static func showLoadingAlert(
        title: String = "",
        message: String = "",
        viewController: UIViewController,
        height : CGFloat = 130
    ) {}
    
}



