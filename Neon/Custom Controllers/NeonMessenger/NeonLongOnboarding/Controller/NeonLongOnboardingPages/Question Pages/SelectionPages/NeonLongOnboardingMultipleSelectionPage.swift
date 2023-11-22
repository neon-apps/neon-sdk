//
//  NeonLongOnboardingMultipleSelectionPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingMultipleSelectionPage: BaseNeonLongOnboardingSelectionPage {
  
  
    var animationDelay = 1.2

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
    }
    
    override func createUI(){
        super.createUI()
       
        
        btnContinue.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset(70)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(65)
        }
        
        whyWeAskLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(btnContinue.snp.bottom).offset(15)
        }
    
      
        disableButton()
        
        scrollView.snp.remakeConstraints { make in
            if subtitleLabel.text != ""{
                make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            }else{
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
        configureOptions()
    }
    

    override func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .multipleSelection(let question, let subtitle, _, let whyDoWeAsk):
            if whyDoWeAsk == nil{
                whyWeAskLabel.isHidden = true
            }
            whyDoWeAskDescription = whyDoWeAsk.changeUsername()
            titleLabel.text = question.changeUsername()
            if subtitle != nil{
                subtitleLabel.text = subtitle.changeUsername()
            }
            
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
     func configureOptions(){
       
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .multipleSelection(_, _, let options, _):
            for option in options {
                animationDelay += 0.2
                let newOptionView = NeonLongOnboardingPageOptionView()
                newOptionView.configure(title: option.title, emoji: option.emoji)
                newOptionView.delegate = self
                newOptionView.isMultipleSelectionEnabled = true
                newOptionView.snp.makeConstraints { make in
                    make.bottom.equalTo(newOptionView.titleLabel.snp.bottom).offset(20)
                }
                mainStack.addArrangedSubview(newOptionView)
                newOptionView.animate(type: .fadeIn, delay: animationDelay)
            }
            
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
        
     
        
        
     
    }
    
    
    override func optionDidSelect(_ option: NeonLongOnboardingPageOptionView) {
        vibrate(style: .medium)
        adjustButton()

    }
    
    override func optionDidDeselect(_ option: NeonLongOnboardingPageOptionView) {
        adjustButton()
    }
    
    func adjustButton(){
        disableButton()
        if let optionViews = mainStack.arrangedSubviews as? [NeonLongOnboardingPageOptionView]{
            for optionView in optionViews {
                if optionView.isSelected{
                    enableButton()
                }
            }
        }
    }
    
  
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            animationDelay += 0.2
            btnContinue.animate(type: .fadeInAndSlideInBottom, delay: animationDelay)
            animationDelay += 0.2
            whyWeAskLabel.animate(type: .fadeInAndSlideInBottom, delay: animationDelay)
        }
    }
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        if !isContinueButtonEnabled{
            return
        }
        NeonLongOnboardingManager.saveResponse(question: titleLabel.text!, responses: getSelectedOptions())
        NeonLongOnboardingManager.moveToNextPage(controller: self)
    }
    
 

}

