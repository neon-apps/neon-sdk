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
class NeonLongPaywallTimelineView : BaseNeonLongPaywallSectionView{
    
    
    var containerView = UIView()

       var itemsStackView = UIStackView()
       
       override func configureSection(type: NeonLongPaywallSectionType) {
           configureView()
           setConstraint()
           switch type {
           case .timeline(let hasContainer, let items):
               containerView.backgroundColor = hasContainer ? manager.constants.containerColor : .clear
               containerView.layer.borderColor = hasContainer ? manager.constants.containerBorderColor.cgColor : UIColor.clear.cgColor
               items.forEach { addItem($0) }
           default:
               fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
           }
           configureLineView()
       }
       
       func configureView() {
    
           containerView.layer.borderWidth = manager.constants.containerBorderWidth
           containerView.layer.cornerRadius = manager.constants.cornerRadius
           addSubview(containerView)
      
           
           itemsStackView.axis = .vertical
           itemsStackView.distribution = .equalSpacing
           itemsStackView.spacing = 20
           addSubview(itemsStackView)
           
   
           itemsStackView.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(30)
               make.left.right.equalToSuperview().inset(manager.constants.horizontalPadding)
           }
       }
       
    func configureLineView(){
        
        if itemsStackView.subviews.count < 2{
            fatalError("You have to add at least 2 items to use timeline section.")
        }
        
        let lineView = UIView()
        lineView.backgroundColor = manager.constants.mainColor.withAlphaComponent(0.4)
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(itemsStackView.subviews.first!.subviews.first!.snp.bottom)
            make.centerX.equalTo(itemsStackView.subviews.first!.subviews.first!.snp.centerX)
            make.bottom.equalTo(itemsStackView.subviews.last!.subviews.first!.snp.top)
            make.width.equalTo(2)
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
       
    private func addItem(_ item: NeonLongPaywallTimelineItem) {
        let itemView = UIView()
        
        let iconImageView = UIImageView()
        if let iconURL = item.iconURL{
            iconImageView.setImage(urlString: iconURL)
        }else{
            iconImageView.image = item.icon
        }
        itemView.addSubview(iconImageView)
        iconImageView.tintColor = manager.constants.ctaButtonTextColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        let iconCircleView1 = UIView()
        itemView.addSubview(iconCircleView1)
        iconCircleView1.layer.cornerRadius = 12
        iconCircleView1.layer.masksToBounds = true
        iconCircleView1.backgroundColor = manager.constants.mainColor
        iconCircleView1.snp.makeConstraints { make in
            make.center.equalTo(iconImageView)
            make.width.height.equalTo(24)
        }
        itemView.sendSubviewToBack(iconCircleView1)

        
        let iconCircleView2 = UIView()
        itemView.addSubview(iconCircleView2)
        iconCircleView2.layer.cornerRadius = 16
        iconCircleView2.layer.masksToBounds = true
        iconCircleView2.backgroundColor = manager.constants.mainColor.withAlphaComponent(0.4)
        iconCircleView2.snp.makeConstraints { make in
            make.center.equalTo(iconImageView)
            make.width.height.equalTo(32)
        }
        itemView.sendSubviewToBack(iconCircleView2)
        
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.textAlignment = .left
        titleLabel.font = Font.custom(size: 20, fontWeight: .SemiBold)
        titleLabel.textColor = manager.constants.mainColor
        itemView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconCircleView2.snp.right).offset(20)
            make.centerY.equalTo(iconImageView)
        }
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.textAlignment = .left
        subtitleLabel.font = Font.custom(size: 16, fontWeight: .Medium)
        subtitleLabel.textColor = manager.constants.secondaryTextColor
        itemView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
        }
        subtitleLabel.sizeToFit()
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = item.description
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        descriptionLabel.textColor = manager.constants.primaryTextColor
        descriptionLabel.numberOfLines = 0
        itemView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        descriptionLabel.sizeToFit()
       
        itemsStackView.addArrangedSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.bottom).offset(30)
        }
    
     
    }





}
