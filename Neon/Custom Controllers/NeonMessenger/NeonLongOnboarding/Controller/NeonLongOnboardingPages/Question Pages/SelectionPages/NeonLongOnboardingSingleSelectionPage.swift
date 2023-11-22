//
//  NeonLongOnboardingSingleSelectionPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingSingleSelectionPage: BaseNeonLongOnboardingSelectionPage {
  
    var animationDelay = 1.2

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func createUI(){
        super.createUI()
       
        whyWeAskLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(35)
        }
        
        scrollView.snp.remakeConstraints { make in
            if subtitleLabel.text != ""{
                make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            }else{
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(whyWeAskLabel.snp.top).offset(-20)
        }
        
        hideButton()
        configureOptions()
    }
    

    override func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .singleSelection(let question, let subtitle, _, let whyDoWeAsk):
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
        case .singleSelection(_, _, let options, _):
            for option in options {
                animationDelay += 0.2
                let newOptionView = NeonLongOnboardingPageOptionView()
                newOptionView.configure(title: option.title, emoji: option.emoji)
                newOptionView.delegate = self
                newOptionView.isMultipleSelectionEnabled = false
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
    
    
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            animationDelay += 0.2
            whyWeAskLabel.animate(type: .fadeInAndSlideInBottom, delay: animationDelay)
        }
    }
    
    override func optionDidSelect(_ option: NeonLongOnboardingPageOptionView) {
        vibrate(style: .medium)
        NeonLongOnboardingManager.saveResponse(question: titleLabel.text!, responses: getSelectedOptions())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            NeonLongOnboardingManager.moveToNextPage(controller: self)
        })
        if let optionViews = mainStack.arrangedSubviews as? [NeonLongOnboardingPageOptionView]{
            for optionView in optionViews {
                if optionView.id != option.id{
                    optionView.setDeselected()
                }
            }
        }
    }
    

}


