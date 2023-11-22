//
//  NeonLongOnboardingGreatFitPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingGreatFitPage: BaseNeonLongOnboardingPage{
    
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    let backgroundImageView = UIImageView()
    let targetBoardAnimationView = NeonAnimationView(animation: .sdk(name: "archery"))
    var benefitView1 = NeonLongOnboardingGreatFitBenefitView()
    var benefitView2 = NeonLongOnboardingGreatFitBenefitView()
    var benefitView3 = NeonLongOnboardingGreatFitBenefitView()
    var benefitView4 = NeonLongOnboardingGreatFitBenefitView()
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
        
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(backButton.snp.bottom).offset(20)
        }
       
        backgroundImageView.image = UIImage(named: "GreatFitPageBackground", in: Bundle.module, compatibleWith: nil)
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
       
        backgroundImageView.addSubview(targetBoardAnimationView)
        targetBoardAnimationView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImageView.snp.centerX)
            make.width.height.equalTo(350)
         }
        targetBoardAnimationView.lottieAnimationView.loopMode = .playOnce
        targetBoardAnimationView.lottieAnimationView.pause()
        
        
   
       
        // Top Left
        
        view.addSubview(benefitView1)
        benefitView1.rotate(degree: -30)
        benefitView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.height.width.equalTo(100)
        }
        
        // Top Right
        
        view.addSubview(benefitView2)
        benefitView2.rotate(degree: -30)
        benefitView2.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.height.width.equalTo(100)
        }
        
        // Bottom Left
        
        view.addSubview(benefitView3)
        benefitView3.rotate(degree: -30)
        benefitView3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(benefitView1.snp.bottom).offset(40)
            make.height.width.equalTo(100)
        }
        
        //Bottom Right
        view.addSubview(benefitView4)
        benefitView4.rotate(degree: -30)
        benefitView4.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(benefitView2.snp.bottom).offset(50)
            make.height.width.equalTo(100)
        }
        
        
        
        
        descriptionLabel.font = Font.custom(size: 16, fontWeight: .Medium)
        descriptionLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(btnContinue.snp.top).offset(-30)
        }
        
        progressView?.isHidden = true
        scrollView.isHidden = true
    }
    
    
    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .greatFit(let title, let subtitle, let benefits, let description):
            titleLabel.text = title.changeUsername()
            subtitleLabel.text = subtitle.changeUsername()
            descriptionLabel.text = description.changeUsername()
            
            if benefits.count != 4{
                fatalError("To use greatFit page, you should add exactly 4 benefits while you are adding the page, inside benefits array.")
            }
            benefitView1.configure(benefit: benefits[0])
            benefitView2.configure(benefit: benefits[1])
            benefitView3.configure(benefit: benefits[2])
            benefitView4.configure(benefit: benefits[3])
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
  
        })
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            backgroundImageView.animate(type: .fadeInAndSlideInTop, delay: 1)
            backgroundImageView.animate(type: .fadeInAndSlideInTop, delay: 1)
            
            targetBoardAnimationView.animate(type: .fadeInAndSlideInTop, delay: 1.1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
              
                self.targetBoardAnimationView.lottieAnimationView.play()
            })
            
            benefitView1.animate(type: .fadeInAndSlideInLeft, delay: 1.3)
            benefitView2.animate(type: .fadeInAndSlideInRight, delay: 1.5)
            benefitView3.animate(type: .fadeInAndSlideInLeft, delay: 1.7)
            benefitView4.animate(type: .fadeInAndSlideInRight, delay: 1.9)
            descriptionLabel.animate(type: .fadeInAndSlideInBottom, delay: 2.4)
            btnContinue.animate(type: .fadeInAndSlideInBottom, delay: 2.5)
        }
    }
    
    
    
}
