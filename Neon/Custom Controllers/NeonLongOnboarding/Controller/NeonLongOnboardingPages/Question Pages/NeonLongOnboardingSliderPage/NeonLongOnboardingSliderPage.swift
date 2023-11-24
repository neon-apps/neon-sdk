//
//  NeonLongOnboardingSliderPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13, *)
class NeonLongOnboardingSliderPage: BaseNeonLongOnboardingPage, UITextFieldDelegate{
  
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    let slider = UISlider()
    var symbol = String()
    var question = String()
    var isSymbolBeforeValue = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    
    override func createUI(){
        super.createUI()
        configurePage()
        
      
        subtitleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
        
        descriptionLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
        }
        
       
        slider.tintColor = NeonLongOnboardingConstants.selectedOptionBorderColor
        view.addSubview(slider)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderDidChanged), for: .valueChanged)
        slider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
        }
    
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
   
        
    }
    
    @objc func sliderDidChanged(){
        if isSymbolBeforeValue{
            descriptionLabel.text = "\(symbol)\(Int(slider.value))"
        }else{
            descriptionLabel.text = "\(Int(slider.value))\(symbol)"
        }
      
    }

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .slider(let question, let item, let descripiton, let symbol, let min, let max, let isSymbolBeforeValue):
            titleLabel.text = question.changeUsername()
            subtitleLabel.attributedText = createAttributedString(item: item, description: descripiton)
            self.symbol = symbol
            self.question = question
            self.isSymbolBeforeValue = isSymbolBeforeValue
            slider.minimumValue = min
            slider.maximumValue = max
            slider.value = (min + max) / 2
            sliderDidChanged()
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    func createAttributedString(item: String, description: String) -> NSAttributedString {
        let attributedItem = NSMutableAttributedString(string: item, attributes: [.font: Font.custom(size: 20, fontWeight: .Medium)])
        let attributedDescription = NSAttributedString(string: description, attributes: [.font: Font.custom(size: 12, fontWeight: .Regular)])
        if #available(iOS 15, *) {
            attributedItem.append(NSAttributedString(" "))
        } else {
            // Fallback on earlier versions
        }
        attributedItem.append(attributedDescription)
        return attributedItem
    }

    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        if isContinueButtonEnabled{
            NeonLongOnboardingManager.saveResponse(question: question, responses: [Int(slider.value)])
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
            slider.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            animationDelay += 1
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
        }
    }
    
    

}

