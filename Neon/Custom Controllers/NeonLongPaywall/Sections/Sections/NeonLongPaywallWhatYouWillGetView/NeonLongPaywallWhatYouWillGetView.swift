//
//  NeonLongPaywallWhatYouWillGetView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallWhatYouWillGetView : BaseNeonLongPaywallSectionView{
    
    
    var containerView = UIView()
       var titleLabel = UILabel()
       var itemsStackView = UIStackView()
       
       override func configureSection(type: NeonLongPaywallSectionType) {
           configureView()
           setConstraint()
           switch type {
           case .whatYouWillGet(let title, let hasContainer, let items):
               containerView.backgroundColor = hasContainer ? manager.constants.containerColor : .clear
               containerView.layer.borderColor = hasContainer ? manager.constants.containerBorderColor.cgColor : UIColor.clear.cgColor
               items.forEach { addItem($0) }
               titleLabel.text = title
           default:
               fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
           }
       }
       
       func configureView() {
    
           containerView.layer.borderWidth = manager.constants.containerBorderWidth
           containerView.layer.cornerRadius = manager.constants.cornerRadius
           addSubview(containerView)
       
           titleLabel.textColor = manager.constants.mainColor
           titleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
           containerView.addSubview(titleLabel)
           titleLabel.numberOfLines = 0
           titleLabel.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(20)
               make.left.right.equalToSuperview().inset(manager.constants.horizontalPadding)
           }
           titleLabel.sizeToFit()
           
           let lineView = UIView()
           lineView.backgroundColor = manager.constants.secondaryTextColor.withAlphaComponent(0.4)
           containerView.addSubview(lineView)
           lineView.snp.makeConstraints { make in
               make.top.equalTo(titleLabel.snp.bottom).offset(15)
               make.left.right.equalToSuperview().inset(manager.constants.horizontalPadding)
               make.height.equalTo(1)
           }
           
           itemsStackView.axis = .vertical
           itemsStackView.distribution = .equalSpacing
           itemsStackView.spacing = 8
           addSubview(itemsStackView)
           
   
           itemsStackView.snp.makeConstraints { make in
               make.top.equalTo(lineView.snp.bottom).offset(15)
               make.left.right.equalTo(titleLabel)
           }
       }
       
       func setConstraint() {
        
           snp.makeConstraints { make in
               make.bottom.equalTo(itemsStackView.snp.bottom)
           }
           containerView.snp.makeConstraints { make in
               make.left.right.top.equalToSuperview()
               make.bottom.equalToSuperview()
           }
       }
       
    private func addItem(_ item: NeonLongPaywallWhatYouWillGetItem) {
        let itemView = UIView()
        
        let emojiLabel = UILabel()
        emojiLabel.text = item.emoji
        emojiLabel.font = Font.custom(size: 20, fontWeight: .Regular)
        itemView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(30)
        }
        emojiLabel.sizeToFit()
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.textAlignment = .left
        titleLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        titleLabel.textColor = manager.constants.primaryTextColor
        itemView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(emojiLabel.snp.right).offset(8)
            make.right.equalToSuperview()
            make.top.equalTo(emojiLabel)
        }
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.textAlignment = .left
        subtitleLabel.font = Font.custom(size: 12, fontWeight: .Medium)
        subtitleLabel.textColor = manager.constants.secondaryTextColor
        subtitleLabel.numberOfLines = 0
        itemView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        subtitleLabel.sizeToFit()
       
        itemsStackView.addArrangedSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(subtitleLabel.snp.bottom).offset(20)
        }
    
     
    }





}
