//
//  NeonLongOnboardingNamePage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingNamePage: BaseNeonLongOnboardingPage, UITextFieldDelegate{
  
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    let nameTextfield = NeonTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        disableButton()
    }
    
    override func createUI(){
        super.createUI()
        configurePage()
        
      
     
   
        descriptionLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
        }
        
       
        nameTextfield.backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        nameTextfield.layer.borderColor = NeonLongOnboardingConstants.optionBorderColor.cgColor
        nameTextfield.layer.borderWidth = 1
        nameTextfield.layer.cornerRadius = 20
        nameTextfield.font = Font.custom(size: 18, fontWeight: .Medium)
        nameTextfield.textColor = NeonLongOnboardingConstants.textColor
        nameTextfield.layer.masksToBounds = true
        nameTextfield.delegate = self
        nameTextfield.placeholder = "John"
        nameTextfield.autocapitalizationType = .words
        nameTextfield.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        view.addSubview(nameTextfield)
        nameTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        nameTextfield.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(65)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
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
        case .name(let title, let subtitle, let description):
            titleLabel.font = Font.custom(size: 22, fontWeight: .SemiBold)
            subtitleLabel.font = Font.custom(size: 20, fontWeight: .Medium)
            descriptionLabel.font = Font.custom(size: 20, fontWeight: .SemiBold)
            titleLabel.text = title
            subtitleLabel.text = subtitle
            descriptionLabel.text = description
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        if isContinueButtonEnabled{
            NeonLongOnboardingConstants.firstName = nameTextfield.text!
            NeonLongOnboardingManager.saveResponse(question: "What is your first name?", responses: [NeonLongOnboardingConstants.firstName!])
            NeonLongOnboardingManager.moveToNextPage(controller: self)
        }

    }
    
    
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            animationDelay += 0.5
            descriptionLabel.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            animationDelay += 0.5
            nameTextfield.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            animationDelay += 1
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
        }
    }
    
    

}
