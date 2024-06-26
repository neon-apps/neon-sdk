//
//  BaseNeonLongOnboardingPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK


@available(iOS 13.0, *)
open class BaseNeonLongOnboardingPage: UIViewController {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let contentView = UIView()
    let scrollView = UIScrollView()
    public var btnContinue = UIButton()
    public var isContinueButtonEnabled = true
    var isViewsAnimated = false
    public var progressView : NeonLongOnboardingProgressView?
    let backButton = UIButton()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createUI()
        
    }
    
    override open func viewDidLayoutSubviews() {
        animateViews()
    }
    func createUI(){
        
        
        view.backgroundColor = NeonLongOnboardingConstants.pageBackgroundColor
        
        guard let currentSection =  NeonLongOnboardingConstants.currentSection else {
            fatalError("You didn't configure the current section.")
        }
        
        guard let indexInSectionQuestions =  NeonLongOnboardingConstants.currentPage?.indexInSectionQuestions else {
            fatalError("You didn't configure the current page.")
        }
        
        guard let currentPageIndex =  NeonLongOnboardingConstants.currentPage?.indexInSection else {
            fatalError("You didn't configure the current page.")
        }
        
        
        
        view.addSubview(btnContinue)
        btnContinue.layer.cornerRadius = 32.5
        btnContinue.layer.masksToBounds = true
        btnContinue.setTitle(NeonLongOnboardingConstants.ctaButtonTitle, for: .normal)
        btnContinue.titleLabel?.font = Font.custom(size: 18, fontWeight: .SemiBold)
        btnContinue.addTarget(self, action: #selector(btnContinueClicked), for: .touchUpInside)
        btnContinue.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(65)
        }
        
        enableButton()
        
        
        progressView = NeonLongOnboardingProgressView(title: currentSection.title, currentIndex: indexInSectionQuestions + 1, numberOfSteps: currentSection.questionPages.count)
        progressView!.upcomingProgressBackgroundColor = NeonLongOnboardingConstants.upcomingProgressBackgroundColor
        progressView!.upcomingProgressTextColor = NeonLongOnboardingConstants.upcomingProgressTextColor
        progressView!.completedProgressBackgroundColor = NeonLongOnboardingConstants.completedProgressBackgroundColor
        progressView!.completedProgressTextColor = NeonLongOnboardingConstants.completedProgressTextColor
        progressView!.configure()
        view.addSubview(progressView!)
        progressView!.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
        
        
 
        view.addSubview(backButton)
        backButton.imageView?.tintColor = NeonLongOnboardingConstants.textColor
        backButton.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
        backButton.isHidden = currentSection.index == 0 && currentPageIndex == 0
        backButton.setImage(NeonSymbols.chevron_left.withConfiguration(size: 25), for: .normal)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
            make.centerY.equalTo((progressView?.titleLabel.snp.centerY)!)
        }
        
      
        titleLabel.font = Font.custom(size: 22, fontWeight: .SemiBold)
        titleLabel.textColor = NeonLongOnboardingConstants.textColor
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(progressView!.snp.bottom).offset(40)
        }
        
        subtitleLabel.font = Font.custom(size: 18, fontWeight: .Medium)
        subtitleLabel.textColor = NeonLongOnboardingConstants.textColor
        subtitleLabel.numberOfLines = 0
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
       
       
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        
        view.bringSubviewToFront(btnContinue)
        
    }
    
    func animateViews(){
        if !isViewsAnimated{
            isViewsAnimated = true
            progressView!.animate(type: .fadeInAndSlideInLeft, delay: 0.5)
        titleLabel.animate(type: .fadeInAndSlideInLeft, delay: 0.7)
        subtitleLabel.animate(type: .fadeInAndSlideInLeft, delay: 1)
        }
    }
    
    public func enableButton(){
        isContinueButtonEnabled = true
        btnContinue.backgroundColor = NeonLongOnboardingConstants.buttonColor
        btnContinue.setTitleColor(NeonLongOnboardingConstants.buttonTextColor, for: .normal)
    }
    public func disableButton(){
        isContinueButtonEnabled = false
        btnContinue.backgroundColor = NeonLongOnboardingConstants.disabledButtonColor
        btnContinue.setTitleColor(NeonLongOnboardingConstants.disabledButtonTextColor, for: .normal)
    }
    
    public func hideButton(){
        btnContinue.isHidden = true
    }
    public func showButton(){
        btnContinue.isHidden = false
    }
    
    @objc open func btnContinueClicked(){
        vibrate(style: .heavy)
    }
    
    @objc func btnBackClicked(){
        NeonLongOnboardingManager.moveToPreviousPage(controller: self)
    }
    
    
}



