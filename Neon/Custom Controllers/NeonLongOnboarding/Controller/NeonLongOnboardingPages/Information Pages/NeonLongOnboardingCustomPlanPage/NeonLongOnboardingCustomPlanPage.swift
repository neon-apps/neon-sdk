//
//  NeonLongOnboardingCustomPlanPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingCustomPlanPage: BaseNeonLongOnboardingPage{
  
 
    let secondTitleLabel = UILabel()
    let descriptionTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let descriptionBackgroundView = UIView()
    let mainTitleLabel = UILabel()
    let customPlanItemsView = NeonLongOnboardingCustomPlanItemsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: descriptionBackgroundView.frame.maxY + 20)
    }
    override func createUI(){
        super.createUI()
        configurePage()
        
        mainTitleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        mainTitleLabel.removeFromSuperview()
        view.addSubview(mainTitleLabel)
        mainTitleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        titleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        titleLabel.removeFromSuperview()
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(0)
        }
        
        subtitleLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        subtitleLabel.removeFromSuperview()
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
     
        contentView.addSubview(customPlanItemsView)
        customPlanItemsView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        secondTitleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        secondTitleLabel.textColor = NeonLongOnboardingConstants.textColor
        secondTitleLabel.numberOfLines = 0
        contentView.addSubview(secondTitleLabel)
        secondTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(customPlanItemsView.snp.bottom).offset(30)
        }
        
       
        descriptionBackgroundView.backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        descriptionBackgroundView.layer.cornerRadius = 10
        descriptionBackgroundView.layer.masksToBounds = true
        
        contentView.addSubview(descriptionBackgroundView)
        
        descriptionTitleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        descriptionTitleLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionTitleLabel.numberOfLines = 0
        descriptionBackgroundView.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        descriptionLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        descriptionLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionLabel.numberOfLines = 0
        descriptionBackgroundView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(30)
        }
        
        descriptionBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
       
        progressView?.isHidden = true
        
      
        
    }
    

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .customPlan(let mainTitle, let planTitle, let planSubtitle, let planItems, let secondTitle, let descriptionTitle, let description):
            mainTitleLabel.text = mainTitle.changeUsername()
            titleLabel.text = planTitle.changeUsername()
            subtitleLabel.text = planSubtitle.changeUsername()
            secondTitleLabel.text = secondTitle.changeUsername()
            customPlanItemsView.items = planItems
            descriptionTitleLabel.text = descriptionTitle.changeUsername()
            descriptionLabel.text = description.changeUsername()
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        NeonLongOnboardingManager.moveToNextPage(controller: self)
    }
    
    
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            subtitleLabel.animate(type: .fadeInAndSlideInLeft, delay: 1.2)
            secondTitleLabel.animate(type: .fadeInAndSlideInLeft, delay: 1.8)
            descriptionBackgroundView.animate(type: .fadeInAndSlideInLeft, delay: 2.0)
            descriptionTitleLabel.animate(type: .fadeIn, delay: 2.2)
            descriptionLabel.animate(type: .fadeIn, delay: 2.4)
            btnContinue.animate(type: .fadeInAndSlideInBottom, delay: 2.6)
            customPlanItemsView.animate()
        }
    }
    
    

}

