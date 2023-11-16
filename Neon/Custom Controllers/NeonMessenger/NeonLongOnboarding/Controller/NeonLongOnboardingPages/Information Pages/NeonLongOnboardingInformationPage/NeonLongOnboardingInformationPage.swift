//
//  NeonLongOnboardingInformationPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingInformationPage: BaseNeonLongOnboardingPage{
  
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
    }
    override func createUI(){
        super.createUI()
        configurePage()
        
      
     
        descriptionLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        descriptionLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
        }
        
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
        progressView?.isHidden = true
        
    }
    

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .information(let title, let subtitle, let description): 
            titleLabel.text = title.changeUsername()
            subtitleLabel.text = subtitle.changeUsername()
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
            animationDelay += 0.5
            descriptionLabel.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            animationDelay += 1
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
        }
    }
    
    

}

