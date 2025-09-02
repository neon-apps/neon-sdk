//
//  NeonSettingsSection.swift
//  AI Note Taker
//
//  Created by Tuna Öztürk on 25.08.2024.
//

import Foundation
import UIKit
import NeonSDK

public enum PurchaseService {
    case revenueCat
    case adapty
}

public enum NeonSettingsSection {
    
    case linkButton(title: String, url: String, icon: UIImage? = nil)
    case toggleButton(title: String? = nil, icon: UIImage? = nil, isDefaultOn : Bool, completion: ((_ isOn : Bool) -> Void)?)
    case rateButton(title: String, icon: UIImage? = nil)
    case reviewButton(title: String? = nil, appId: String, icon: UIImage? = nil)
    case shareButton(title: String? = nil, appId: String, icon: UIImage? = nil)
    case copyUserIdButton(title: String? = nil, icon: UIImage? = nil)
    case contactButton(title: String? = nil, email: String, icon: UIImage? = nil)
    case customButton(title: String,  icon: UIImage? = nil, action: (() -> Void)?)
    case premiumButton(title: String? = nil, icon: UIImage? = nil, backgroundColor: UIColor, borderColor: UIColor, titleColor: UIColor, iconTintColor: UIColor?, completion: (() -> Void)?)
    case restorePurchaseButton(title: String? = nil, icon: UIImage? = nil, service: PurchaseService)
    case titleSection(title: String, textColor: UIColor? = nil)
    case customView(view: UIView, height: CGFloat? = nil)
    case spacing(height: CGFloat)
    
    func view(buttonTextColor: UIColor, buttonBackgroundColor: UIColor, buttonBorderColor: UIColor, buttonCornerRadius: CGFloat, buttonHeight: CGFloat, iconTintColor: UIColor?, primaryTextColor: UIColor, mainColor: UIColor, controller: UIViewController) -> UIView? {
        switch self {
        case .linkButton(let title, let url, let icon):
            return createButton(title: title, icon: icon, chevron: true, action: {
                NeonSettingsActionManager.openURL(url)
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
            
        case .rateButton(let title, let icon):
            return createButton(title: title, icon: icon, chevron: true, action: {
                NeonSettingsActionManager.rateApp()
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .reviewButton(let title, let appId, let icon):
            return createButton(title: title ?? "Write a Review", icon: icon, chevron: true, action: {
                NeonSettingsActionManager.writeReview(appId: appId)
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .shareButton(let title, let appId, let icon):
            return createButton(title: title ?? "Share the App", icon: icon, chevron: true, action: {
                NeonSettingsActionManager.shareApp(from: controller, appId: appId)
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .copyUserIdButton(let title, let icon):
            return createButton(title: title ?? "Copy User ID", icon: icon, chevron: true, action: {
                NeonSettingsActionManager.copyUserID(controller: controller)
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .contactButton(let title, let email, let icon):
            return createButton(title: title ?? "Contact Support", icon: icon, chevron: true, action: {
                NeonSettingsActionManager.contactSupport(email: email)
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .customButton(let title, let icon, let action):
            return createButton(title: title, icon: icon, chevron: true, action: action, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .premiumButton(let title, let icon, let backgroundColor, let borderColor, let titleColor, let iconTintColor, let completion):
            return createButton(title: title ?? "Upgrade to Premium", icon: icon, chevron: false, action: {
                NeonSettingsActionManager.upgradeToPremium(completion: completion)
            }, buttonTextColor: titleColor, buttonBackgroundColor: backgroundColor, buttonBorderColor: borderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .restorePurchaseButton(let title, let icon, let service):
            return createButton(title: title ?? "Restore Purchases", icon: icon, chevron: true, action: {
                NeonSettingsActionManager.restorePurchases(using: service, mainColor: mainColor, controller: controller)
            }, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor)
        
        case .titleSection(let title, let textColor):
            return createTitleView(title: title, textColor: textColor ?? primaryTextColor)
            
        case .customView(let view, let height):
            if let height{
                view.snp.makeConstraints { make in
                    make.height.equalTo(height)
                }
            }
            return view
            
        case .spacing(let height):
            let spacerView = UIView()
            spacerView.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
            return spacerView
        case .toggleButton(title: let title, icon: let icon, isDefaultOn : let isDefaultOn, completion: let completion):
            return createToggleButton(title: title, icon: icon, isDefaultOn: isDefaultOn, completion: completion, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonBorderColor: buttonBorderColor, buttonCornerRadius: buttonCornerRadius, buttonHeight: buttonHeight, iconTintColor: iconTintColor, mainColor: mainColor)
        }
    }
    
    private func createToggleButton(title: String?, icon: UIImage?, isDefaultOn : Bool,  completion: ((_ isOn: Bool) -> Void)?, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, buttonBorderColor: UIColor, buttonCornerRadius: CGFloat, buttonHeight: CGFloat, iconTintColor: UIColor?, mainColor : UIColor) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = buttonBackgroundColor
        containerView.layer.cornerRadius = buttonCornerRadius
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = buttonBorderColor.cgColor
        containerView.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }

        let label = UILabel()
        label.text = title
        label.textColor = buttonTextColor
        label.font = NeonSettingsControllerConstants.buttonTitleFont
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = isDefaultOn
        toggleSwitch.onTintColor = mainColor
        toggleSwitch.addAction(UIAction { _ in
            completion?(toggleSwitch.isOn)
        }, for: .valueChanged)

        containerView.addSubview(label)
        containerView.addSubview(toggleSwitch)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(icon == nil ? 20 : 40)
            make.centerY.equalToSuperview()
        }

        toggleSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }

        if let icon = icon {
            let iconImageView = UIImageView(image: icon)
            iconImageView.contentMode = .scaleAspectFit
            containerView.addSubview(iconImageView)
            
            iconImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(20)
            }
            
            label.snp.remakeConstraints { make in
                make.left.equalTo(iconImageView.snp.right).offset(8)
                make.centerY.equalToSuperview()
            }
            
            if let tintColor = iconTintColor {
                iconImageView.tintColor = tintColor
            }
        }

        return containerView
    }
    
    private func createButton(title: String, icon: UIImage?, chevron: Bool, action: (() -> Void)? = nil, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, buttonBorderColor: UIColor, buttonCornerRadius: CGFloat, buttonHeight: CGFloat, iconTintColor: UIColor?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(buttonTextColor, for: .normal)
        button.titleLabel?.font = NeonSettingsControllerConstants.buttonTitleFont
        button.contentHorizontalAlignment = .left
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = buttonCornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = buttonBorderColor.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: icon == nil ? 20 : 40, bottom: 0, right: 0)
        button.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }
        
        if let icon = icon {
            let iconImageView = UIImageView(image: icon)
            iconImageView.contentMode = .scaleAspectFit
            button.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(12)
                make.width.height.equalTo(20)
            }
            if let tintColor = iconTintColor {
                iconImageView.tintColor = tintColor
            }
        }
        
        if chevron {
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.contentMode = .scaleAspectFit
            chevronImageView.tintColor = buttonTextColor
            button.addSubview(chevronImageView)
            chevronImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-12)
                make.width.equalTo(12)
            }
        }
        
        if let action = action {
            button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        }
        
        return button
    }
    
    private func createTitleView(title: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = NeonSettingsControllerConstants.sectionTitleFont
        label.textAlignment = .left
        label.textColor = textColor
        return label
    }
}
