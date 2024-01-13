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
class NeonLongPaywallPlanComparisonView : BaseNeonLongPaywallSectionView{
    
    var basicLabel = UILabel()
    let lblPremium = NeonPaddingLabel()
    var containerView = UIView()
    
       var itemsStackView = UIStackView()
       var allItems = [NeonLongPaywallPlanComparisonItem]()
       override func configureSection(type: NeonLongPaywallSectionType) {
           configureView()
           setConstraint()
           switch type {
           case .planComparison(let items):
               allItems = items
               items.forEach { item in
                   addItem(item)
               }
           default:
               fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
           }
           
           lblPremium.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(20)
               make.centerX.equalTo(itemsStackView.subviews.first!.subviews[1].snp.centerX)
           }
           basicLabel.snp.makeConstraints { make in
               make.centerY.equalTo(lblPremium)
               make.centerX.equalTo(itemsStackView.subviews.first!.subviews[2].snp.centerX)
           }
       }
       
       func configureView() {
    
       
           addSubview(containerView)
        
           lblPremium.text = "PRO"
           lblPremium.backgroundColor = manager.constants.mainColor
           lblPremium.textColor = manager.constants.ctaButtonTextColor
           lblPremium.font = Font.custom(size: 13, fontWeight: .Bold)
           lblPremium.numberOfLines = 0
           lblPremium.textAlignment = .center
           lblPremium.layer.cornerRadius = 4
           lblPremium.layer.masksToBounds = true
           containerView.addSubview(lblPremium)
         
           lblPremium.leftInset = 6
           lblPremium.rightInset = 6
           lblPremium.topInset = 2
           lblPremium.bottomInset = 2
           
      
           basicLabel.text = "Basic"
           basicLabel.textColor = manager.constants.primaryTextColor
           basicLabel.font = Font.custom(size: 12, fontWeight: .SemiBold)
           containerView.addSubview(basicLabel)
           basicLabel.numberOfLines = 0
          
           basicLabel.sizeToFit()
     
           
           
           itemsStackView.axis = .vertical
           itemsStackView.distribution = .equalSpacing
           itemsStackView.spacing = 4
           addSubview(itemsStackView)
           
   
           itemsStackView.snp.makeConstraints { make in
               make.top.equalTo(basicLabel.snp.bottom).offset(15)
               make.left.right.equalToSuperview()
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
       
    private func addItem(_ item: NeonLongPaywallPlanComparisonItem) {
        let featureView = UIButton()
        let answerView = UIView()
        
       
        let featureLabel = UILabel()
        featureLabel.text = item.feature
        featureLabel.textColor = manager.constants.primaryTextColor
        featureLabel.textAlignment = .left
        featureLabel.font = Font.custom(size: 12, fontWeight: .SemiBold)
        featureView.addSubview(featureLabel)


        
        let imgCheckmarkPro = UIImageView()
        imgCheckmarkPro.image = NeonSymbols.checkmark
        imgCheckmarkPro.contentMode = .scaleAspectFit
        imgCheckmarkPro.tintColor = UIColor(red: 0.23, green: 0.68, blue: 0.27, alpha: 1)
        featureView.addSubview(imgCheckmarkPro)
        imgCheckmarkPro.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        let imgCheckmarkBasic = UIImageView()
        imgCheckmarkBasic.contentMode = .scaleAspectFit
        featureView.addSubview(imgCheckmarkBasic)
        imgCheckmarkBasic.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(100)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        
        switch item.availability {
        case .locked:
            imgCheckmarkBasic.tintColor = manager.constants.primaryTextColor
            imgCheckmarkBasic.image = NeonSymbols.lock
        case .available:
            imgCheckmarkBasic.tintColor = UIColor(red: 0.23, green: 0.68, blue: 0.27, alpha: 1)
            imgCheckmarkBasic.image = NeonSymbols.checkmark
        case .limited:
            imgCheckmarkBasic.isHidden = true
            
            let limitedLabel = UILabel()
            limitedLabel.text = "Limited"
            limitedLabel.textColor = manager.constants.primaryTextColor
            limitedLabel.textAlignment = .center
            limitedLabel.font = Font.custom(size: 12, fontWeight: .Medium)
            featureView.addSubview(limitedLabel)
            limitedLabel.snp.makeConstraints { make in
                make.center.equalTo(imgCheckmarkBasic)
            }
        }
        
        
        itemsStackView.addArrangedSubview(featureView)
        featureView.layer.cornerRadius = manager.constants.cornerRadius
        featureView.layer.masksToBounds = true
        featureView.layer.borderColor = UIColor.clear.cgColor
        featureView.layer.borderWidth = manager.constants.containerBorderWidth
        featureView.backgroundColor = manager.constants.containerColor
        featureView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(featureLabel.snp.bottom).offset(15)
        }
    
        featureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(imgCheckmarkBasic.snp.left).offset(-20)
        }
        featureLabel.numberOfLines = 0
        featureLabel.sizeToFit()

        
    }





}
