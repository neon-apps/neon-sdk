//
//  NeonLongOnboardingLetsGoPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingLetsGoPage: BaseNeonLongOnboardingPage{
  
    let imageView = UIImageView()
    let btnNo = UIButton()
    var isNoButtonHidden = false
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
        
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(btnContinue.snp.top)
        }

        
      
        
        
       
        btnNo.layer.cornerRadius = 32.5
        btnNo.layer.masksToBounds = true
        btnNo.setTitle("No", for: .normal)
        btnNo.titleLabel?.font = Font.custom(size: 18, fontWeight: .SemiBold)
        btnNo.layer.borderColor = NeonLongOnboardingConstants.buttonColor.cgColor
        btnNo.layer.borderWidth = 2
        btnNo.setTitleColor(NeonLongOnboardingConstants.textColor, for: .normal)
        btnNo.addTarget(self, action: #selector(btnContinueClicked), for: .touchUpInside)
    
        if !isNoButtonHidden{
            view.addSubview(btnNo)
            btnNo.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
                make.left.equalToSuperview().inset(20)
                make.height.equalTo(65)
                make.width.equalTo(130)
            }
            btnContinue.snp.remakeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
                make.right.equalToSuperview().inset(20)
                make.height.equalTo(65)
                make.left.equalTo(btnNo.snp.right).offset(20)
            }
        }
        
       
        
        btnContinue.setTitle("Sure! Let's Go!", for: .normal)
   
        enableButton()
     
        scrollView.isHidden = true
        progressView?.isHidden = true
        
    }
    

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .letsGo(let question, let image, let hideNoButton):
            titleLabel.text = question.changeUsername()
            imageView.image = image
            isNoButtonHidden = hideNoButton
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
            imageView.animate(type: .fadeInAndSlideInLeft, delay: 1)
            btnContinue.animate(type: .fadeInAndSlideInBottom, delay: 1.5)
            btnNo.animate(type: .fadeInAndSlideInBottom, delay: 1.5)
        }
    }
    
    

}
