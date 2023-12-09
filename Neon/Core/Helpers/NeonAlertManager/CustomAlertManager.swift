//
//  File 2.swift
//  
//
//  Created by Tuna Öztürk on 22.10.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class CustomAlertManager {
    
    private static var currentAlertView: UIView?
    private static var backgroundColor: UIColor = .white
    private static var textColor: UIColor = .black
    private static var buttonColor: UIColor = .blue
    private static var layerType: LayerType = .clear
    private static var animationType: AnimationType = .slideVertically
   
    private static let backgroundView = UIView()
    private static var blurBackgroundView = UIVisualEffectView()
    private static var fixedWidth : CGFloat?
    private static var verticalPadding : CGFloat = 20
    public static var isConfigured = false
    
    public static func configure(backgroundColor: UIColor, textColor: UIColor, buttonColor: UIColor, layerType: LayerType, animationType: AnimationType, fixedWidth : CGFloat? = nil) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.buttonColor = buttonColor
            self.layerType = layerType
            self.animationType = animationType
            self.isConfigured = true
            self.fixedWidth = fixedWidth
        }
    
    
    public static func present(viewController: UIViewController, title: String?, message: String?, icon: UIImage? = nil, iconTintColor: UIColor? = nil, iconSize: CGSize = CGSize(width: 50, height: 50), verticalPadding : CGFloat = 20, buttons: [CustomAlertButton]? = nil) {
     
        if !isConfigured{
            fatalError("You have to configure the CustomAlertManager before presenting it. Use NeonAlertManager.custom.configure method in your AppDelegate's didFinishLaunchingWithOptions.")
        }
        
        backgroundView.removeFromSuperview()
        viewController.view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundView.addSubview(blurBackgroundView)
        blurBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blurBackgroundView.isHidden = true
       
        
        
        let alertView = UIView()
        alertView.backgroundColor = backgroundColor
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        
        let iconImageView = UIImageView(image: icon)
        if iconTintColor != nil{
            iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = iconTintColor
        }
        iconImageView.contentMode = .scaleAspectFit
        alertView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.top).offset(verticalPadding)
            make.centerX.equalTo(alertView.snp.centerX)
            make.width.equalTo(iconSize.width)
            make.height.equalTo(iconSize.height)
        }
        iconImageView.isHidden = (icon == nil)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Font.custom(size: 18, fontWeight: .Bold)
        titleLabel.textColor = textColor
        titleLabel.numberOfLines = 0
        alertView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(verticalPadding)
            make.centerX.equalTo(alertView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        if icon == nil{
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(alertView.snp.top).offset(verticalPadding)
                make.centerX.equalTo(alertView.snp.centerX)
            }
        }
        let subtitleLabel = UILabel()
        subtitleLabel.text = message
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = textColor
        subtitleLabel.font = Font.custom(size: 14, fontWeight: .Regular)
        alertView.addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
      
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
      
        var alertButtons = [CustomAlertButton]()
        if let buttons = buttons, !buttons.isEmpty {
            alertButtons = buttons
        }else{
            alertButtons = [CustomAlertButton(title: "Okay", buttonType: .background)]
        }
        
        for button in alertButtons {
            
            let buttonView = UIButton()
            buttonView.setTitle(button.title, for: .normal)
            buttonView.setTitleColor(button.overrideTextColor ?? textColor, for: .normal)
            buttonView.addAction {
                dismissCurrentAlertView(controller: viewController, stackView: stackView, alertView: alertView)
                if let completion = button.completion{
                    completion()
                }
            }

            buttonView.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
            buttonView.layer.cornerRadius = 10
            buttonView.layer.masksToBounds = true
            
            switch button.buttonType {
            case .background:
                buttonView.backgroundColor = buttonColor
                break
            case .border:
                buttonView.layer.borderWidth = 2
                buttonView.layer.borderColor = buttonColor.cgColor
                break
            case .text:
                break
            }
            stackView.addArrangedSubview(buttonView)
        }
        
        alertView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(30)
            if (buttons != nil){
                make.height.equalTo(buttons!.count * 60)
            }else{
                make.height.equalTo(50)
            }
        }
        
        viewController.view.addSubview(alertView)
        
        if animationType == .slideVertically{
       
            if let fixedWidth{
                alertView.snp.makeConstraints { make in
                    make.top.equalTo(viewController.view.snp.bottom)
                    make.width.equalTo(fixedWidth)
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                }
            }else{
                alertView.snp.makeConstraints { make in
                    make.top.equalTo(viewController.view.snp.bottom)
                    make.leading.trailing.equalToSuperview().inset(50)
                    make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                }
            }
           
        }else{
            
            if let fixedWidth{
                alertView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(fixedWidth)
                    make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                }
                
            }else{
                alertView.snp.makeConstraints { make in
                    make.right.equalTo(viewController.view.snp.left)
                    make.centerY.equalToSuperview()
                    make.width.equalToSuperview().inset(50)
                    make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                }
            }
            
           
        }
      
        
    
        
        currentAlertView = alertView
        presentAlertView(controller: viewController, stackView: stackView, alertView: alertView)

    }
    
    private static func showBackground(){
        
        
        switch CustomAlertManager.layerType{
        case .darkSolid:
            CustomAlertManager.backgroundView.backgroundColor = .black
            CustomAlertManager.backgroundView.alpha = 0.6
            break
        case .lightBlur:
            blurBackgroundView.effect = UIBlurEffect(style: .light)
            CustomAlertManager.backgroundView.backgroundColor = .clear
            CustomAlertManager.backgroundView.alpha = 1
            CustomAlertManager.blurBackgroundView.isHidden = false
            break
        case .darkBlur:
            blurBackgroundView.effect = UIBlurEffect(style: .dark)
            CustomAlertManager.backgroundView.backgroundColor = .clear
            CustomAlertManager.backgroundView.alpha = 1
            CustomAlertManager.blurBackgroundView.isHidden = false
            break
        case .lightSolid:
            CustomAlertManager.backgroundView.backgroundColor = .white
            CustomAlertManager.backgroundView.alpha = 0.6
            break
        case .clear:
            break
        }
        
    }
    
    private static func hideBackground(){
        CustomAlertManager.backgroundView.alpha = 0
    }
    
    private static func removeBackground(){
        CustomAlertManager.backgroundView.removeFromSuperview()
    }
    private static func presentAlertView(controller : UIViewController, stackView : UIStackView, alertView : UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            
            guard let alertView = currentAlertView else { return }
            
            if let fixedWidth{
                alertView.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.width.equalTo(fixedWidth)
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                }
            }else{
                alertView.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.trailing.equalToSuperview().inset(50)
                    make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                }
            }
            
            
            UIView.animate(withDuration: 0.5, animations: {
                showBackground()
                controller.view.layoutIfNeeded()
            }) { _ in
               
            }
        })
    }
    
    private static func dismissCurrentAlertView(controller : UIViewController, stackView : UIStackView, alertView : UIView) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            
            
            if animationType == .slideVertically{
                
                if let fixedWidth{
                    alertView.snp.remakeConstraints { make in
                        make.bottom.equalTo(controller.view.snp.top)
                        make.width.equalTo(fixedWidth)
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                    }
                }else{
                    alertView.snp.remakeConstraints { make in
                        make.bottom.equalTo(controller.view.snp.top)
                        make.leading.trailing.equalToSuperview().inset(50)
                        make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                    }
                }
                
               
                
            }else{
                
                if let fixedWidth{
                    alertView.snp.remakeConstraints { make in
                        make.left.equalTo(controller.view.snp.right)
                        make.centerY.equalToSuperview()
                        make.width.equalTo(fixedWidth)
                        make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                    }
                }else{
                    alertView.snp.remakeConstraints { make in
                        make.left.equalTo(controller.view.snp.right)
                        make.centerY.equalToSuperview()
                        make.width.equalToSuperview().inset(50)
                        make.bottom.equalTo(stackView.snp.bottom).offset(verticalPadding)
                    }
                }
                
               
            }
           
            UIView.animate(withDuration: 0.5, animations: {
                controller.view.layoutIfNeeded()
                hideBackground()
            }) { _ in
                alertView.removeFromSuperview()
                currentAlertView = nil
                removeBackground()
            }
        })

    }
    
    
    public enum LayerType {
        case darkBlur
        case lightBlur
        case darkSolid
        case lightSolid
        case clear
    }
    public enum AnimationType {
        case slideVertically
        case slideHorizontally
    }
    
  

}

open class CustomAlertButton : NSObject {
    public init(title: String, buttonType: CustomAlertButton.ButtonType, overrideTextColor: UIColor? = nil, completion: (() -> Void)? = nil) {
        self.title = title
        self.buttonType = buttonType
        self.completion = completion
        self.overrideTextColor = overrideTextColor
    }
    
    let title: String
    let buttonType: ButtonType
    let overrideTextColor : UIColor?
    let completion: (() -> Void)?
    
}

extension CustomAlertButton {
    public enum ButtonType {
        case background
        case border
        case text
        
    }
}

