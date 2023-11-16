//
//  NeonLongOnboardingNumberPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingNumberPage: BaseNeonLongOnboardingPage, UITextFieldDelegate, NeonNumericTextfieldDelegate{
  
    
  
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    var numberField = NeonNumericTextfield()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        disableButton()
        adjustKeyboardNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.numberField.becomeFirstResponder()
        })
        configurePage()
    }
    
    override func createUI(){
        super.createUI()
        configurePage()
        configureNumberfield()
        
       
        numberField.digitColor = NeonLongOnboardingConstants.textColor
        numberField.digitFont = Font.custom(size: 30, fontWeight: .SemiBold)
        numberField.digitCornerStyle = .radius(10)
        numberField.digitBorderColor = NeonLongOnboardingConstants.optionBorderColor
        numberField.nextDigitBorderColor = NeonLongOnboardingConstants.selectedOptionBorderColor
        numberField.delegate = self
        view.addSubview(numberField)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.numberField.becomeFirstResponder()
        })
        numberField.snp.makeConstraints { make in

            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.width.equalTo(110)
        }
        
        

        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        

        
    }
    
    func adjustKeyboardNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            
            btnContinue.snp.remakeConstraints{ make in
                make.bottom.equalToSuperview().inset(keyboardHeight + 30)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(65)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
        @objc func keyboardWillHide(_ notification: Notification) {
          
                btnContinue.snp.remakeConstraints{ make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
                    make.left.right.equalToSuperview().inset(20)
                    make.height.equalTo(65)
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
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
        case .number(let question, let subtitle, _):
            titleLabel.text = question.changeUsername()
            subtitleLabel.text = subtitle.changeUsername()
        
          
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    func configureNumberfield(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .number(_, _, let digitCount):
            numberField.numberOfDigits = digitCount
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        NeonLongOnboardingManager.saveResponse(question: titleLabel.text!, responses: [Int(numberField.text) ?? numberField.text])
        if isContinueButtonEnabled{
            self.numberField.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                NeonLongOnboardingManager.moveToNextPage(controller: self)
            })
        }
       
    }
    
    func digitsDidFinish(_ textfield: NeonNumericTextfield) {
        enableButton()
    }
    
    func digitsDidChange(_ textfield: NeonNumericTextfield) {
        if textfield.numberOfDigits == textfield.numberOfFilledDigits{
            enableButton()
        }else{
            disableButton()
        }
       
    }
    
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            animationDelay += 0.2
            numberField.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            animationDelay += 0.2
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
        }
    }
    
    

}
