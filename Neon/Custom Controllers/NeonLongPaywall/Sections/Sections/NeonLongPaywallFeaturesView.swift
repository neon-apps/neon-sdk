//
//  NeonLongPaywallFeaturesView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallFeaturesView : BaseNeonLongPaywallSectionView{
    
    
    
    let verticalStackView = UIStackView()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()
        setConstraint()
    
        switch type {
        case .features(let items, let textColor, let font, let iconColor, let offset ):
            verticalStackView.addArrangedSubview(UIView())
            items.forEach({addItem(item: $0, iconColor: iconColor, textColor: textColor, font: font)})
            verticalStackView.addArrangedSubview(UIView())
            
            verticalStackView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview().offset(offset ?? 0)
                make.width.lessThanOrEqualToSuperview()
            }
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
    }
    
    
    func configureView(){
        
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 10
        addSubview(verticalStackView)
        
    }
    func addItem(item : NeonPaywallFeature, iconColor : UIColor?, textColor : UIColor?,  font : UIFont?){
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 10
        let icon = UIImageView()
       
       
            
            if let image = item.icon{
                if iconColor != nil{
                    icon.image = image.withRenderingMode(.alwaysTemplate)
                    icon.tintColor = iconColor
                }else{
                    icon.image = item.icon
                }
            }else if let url = item.iconURL{
                if iconColor != nil{
                    icon.tintColor = iconColor
                }
                icon.setImage(urlString: url)
                
            }
        
        icon.contentMode = .scaleAspectFit
        horizontalStack.addArrangedSubview(icon)
        
        let label = UILabel()
        label.text = item.title
        label.textColor = textColor ?? manager.constants.primaryTextColor
        label.font = font ?? Font.custom(size: 14, fontWeight: .SemiBold)
        label.numberOfLines = 0
        horizontalStack.addArrangedSubview(label)
        
        
        verticalStackView.addArrangedSubview(horizontalStack)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
    }
    
    func setConstraint(){
        snp.makeConstraints { make in
            make.width.equalTo(300)
            make.bottom.equalTo(verticalStackView.snp.bottom)
        }
    }
    
    
    
}
