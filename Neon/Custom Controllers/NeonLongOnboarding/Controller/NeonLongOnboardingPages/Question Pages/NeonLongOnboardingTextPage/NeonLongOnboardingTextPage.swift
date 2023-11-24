//
//  NeonLongOnboardingTextPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingTextPage: BaseNeonLongOnboardingPage, UITextFieldDelegate{
  
    var animationDelay = 1.2
    let inputTextfield = NeonTextField()
    var question = String()
    var subtitle : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        disableButton()
    }
    
    override func createUI(){
        super.createUI()
        configurePage()

        inputTextfield.backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        inputTextfield.layer.borderColor = NeonLongOnboardingConstants.optionBorderColor.cgColor
        inputTextfield.layer.borderWidth = 1
        inputTextfield.layer.cornerRadius = 20
        inputTextfield.font = Font.custom(size: 18, fontWeight: .Medium)
        inputTextfield.textColor = NeonLongOnboardingConstants.textColor
        inputTextfield.layer.masksToBounds = true
        inputTextfield.delegate = self
        inputTextfield.autocapitalizationType = .sentences
        inputTextfield.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        view.addSubview(inputTextfield)
        inputTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        inputTextfield.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(65)
            if subtitle == nil{
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
            }else{
                make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            }
        
        }
        
        
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
   
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != ""{
            enableButton()
        }else{
            disableButton()
        }
    }

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .text(let question, let subtitle, let placeholder):
            inputTextfield.placeholder = placeholder
            titleLabel.font = Font.custom(size: 22, fontWeight: .SemiBold)
            subtitleLabel.font = Font.custom(size: 20, fontWeight: .Medium)
            titleLabel.text = question.changeUsername()
            subtitleLabel.text = subtitle.changeUsername()
            self.question = question
            self.subtitle = subtitle
            
           
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        if isContinueButtonEnabled{
            NeonLongOnboardingManager.saveResponse(question: question, responses: [inputTextfield.text!])
            NeonLongOnboardingManager.moveToNextPage(controller: self)
        }

    }
    
    
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            animationDelay += 0.5
            inputTextfield.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            animationDelay += 1
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
        }
    }
    
    

}

