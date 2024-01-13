//
//  NeonLongPaywallFAQView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallFAQView : BaseNeonLongPaywallSectionView{
    
    
    var containerView = UIView()
       var titleLabel = UILabel()
       var itemsStackView = UIStackView()
       var allItems = [NeonLongPaywallFAQItem]()
       override func configureSection(type: NeonLongPaywallSectionType) {
           configureView()
           setConstraint()
           switch type {
           case .faq(let title, let items):
               allItems = items
               items.enumerated().forEach { item, index in
                   addItem(index, item)
               }
               titleLabel.text = title
           default:
               fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
           }
       }
       
       func configureView() {
    
           containerView.layer.cornerRadius = manager.constants.cornerRadius
           addSubview(containerView)
       
           titleLabel.textColor = manager.constants.mainColor
           titleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
           containerView.addSubview(titleLabel)
           titleLabel.numberOfLines = 0
           titleLabel.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(20)
               make.left.right.equalToSuperview()
           }
           titleLabel.sizeToFit()
     
           
           
           itemsStackView.axis = .vertical
           itemsStackView.distribution = .equalSpacing
           itemsStackView.spacing = 8
           addSubview(itemsStackView)
           
   
           itemsStackView.snp.makeConstraints { make in
               make.top.equalTo(titleLabel.snp.bottom).offset(15)
               make.left.right.equalTo(titleLabel)
           }
       }
       
       func setConstraint() {
        
           snp.makeConstraints { make in
               make.bottom.equalTo(itemsStackView.snp.bottom).offset(20)
           }
           containerView.snp.makeConstraints { make in
               make.left.right.top.equalToSuperview()
               make.bottom.equalToSuperview()
           }
       }
       
    private func addItem(_ item: NeonLongPaywallFAQItem, _ index: Int) {
        let questionView = UIButton()
        let arrowImage = UIImageView()
        questionView.addSubview(arrowImage)
       
        let titleLabel = UILabel()
        let fullText = "\(index + 1) - \(item.question)"
        let attributedString = NSMutableAttributedString(string: fullText)
        let rangeOfIndex = NSRange(location: 0, length: String("\(index + 1) -").count)
        attributedString.addAttribute(.foregroundColor, value: manager.constants.mainColor, range: rangeOfIndex)
        let rangeOfRemainingText = NSRange(location: rangeOfIndex.length, length: fullText.count - rangeOfIndex.length)
        attributedString.addAttribute(.foregroundColor, value: manager.constants.primaryTextColor, range: rangeOfRemainingText)
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        questionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(arrowImage.snp.left).offset(-10)
        }
        titleLabel.sizeToFit()

        
      
        arrowImage.image = NeonSymbols.chevron_down
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.tintColor = manager.constants.mainColor
        arrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(20)
        }
        
        
        itemsStackView.addArrangedSubview(questionView)
        questionView.layer.cornerRadius = manager.constants.cornerRadius
        questionView.layer.masksToBounds = true
        questionView.layer.borderColor = UIColor.clear.cgColor
        questionView.layer.borderWidth = manager.constants.containerBorderWidth
        questionView.backgroundColor = manager.constants.containerColor
        questionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(15)
        }
        var isHidden = true
     
        
       
        
        let answerTitleLabel = UILabel()
        answerTitleLabel.text = item.answerTitle
        answerTitleLabel.textAlignment = .left
        answerTitleLabel.font = Font.custom(size: 12, fontWeight: .Medium)
        answerTitleLabel.textColor = manager.constants.primaryTextColor
        answerTitleLabel.numberOfLines = 0
        questionView.addSubview(answerTitleLabel)
        answerTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.right.equalToSuperview().inset(15)
        }
        
        answerTitleLabel.sizeToFit()
        
        let answerSubtitleLabel = UILabel()
        answerSubtitleLabel.text = item.answerSubtitle
        answerSubtitleLabel.textAlignment = .left
        answerSubtitleLabel.font = Font.custom(size: 10, fontWeight: .Medium)
        answerSubtitleLabel.textColor = manager.constants.secondaryTextColor
        answerSubtitleLabel.numberOfLines = 0
        questionView.addSubview(answerSubtitleLabel)
        answerSubtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(answerTitleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(15)
        }
        
        answerSubtitleLabel.sizeToFit()
        
    
     
        
        questionView.addAction {
        
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            
            isHidden.toggle()
    
            if isHidden{
                questionView.layer.borderColor = UIColor.clear.cgColor
                questionView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(titleLabel.snp.bottom).offset(15)
                }
                arrowImage.image = NeonSymbols.chevron_down
                
  
                
                
            }else{
                questionView.layer.borderColor = self.manager.constants.selectedContainerBorderColor.cgColor
                questionView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(answerSubtitleLabel.snp.bottom).offset(15)
                }
     
                arrowImage.image = NeonSymbols.chevron_up
               
            }
            
            
                UIView.animate(withDuration: 0.25) {
                    self.itemsStackView.layoutIfNeeded()
                    self.superview!.superview!.layoutIfNeeded()
                }
                
            
        }
        
    }





}
