//
//  NeonLongOnboardingStatementPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingStatementPage: BaseNeonLongOnboardingPage{
  
    let imageView = UIImageView()
    let btnNo = UIButton()
    let backgroundView = UIView()
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
        
        
        
       
        
       
        view.addSubview(backgroundView)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(btnContinue.snp.top).offset(-40)
        }
        view.sendSubviewToBack(backgroundView)
        
        subtitleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        subtitleLabel.removeFromSuperview()
        backgroundView.addSubview(subtitleLabel)
        subtitleLabel.textAlignment = .center
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        backgroundView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.bottom.left.right.equalToSuperview()
        }
        

        
      
        
        
        view.addSubview(btnNo)
        btnNo.layer.cornerRadius = 32.5
        btnNo.layer.masksToBounds = true
        btnNo.setTitle("No", for: .normal)
        btnNo.titleLabel?.font = Font.custom(size: 18, fontWeight: .SemiBold)
        btnNo.layer.borderColor = NeonLongOnboardingConstants.buttonColor.cgColor
        btnNo.layer.borderWidth = 2
        btnNo.setTitleColor(NeonLongOnboardingConstants.textColor, for: .normal)
        btnNo.addTarget(self, action: #selector(btnContinueClicked), for: .touchUpInside)
        btnNo.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(65)
            make.right.equalTo(view.snp.centerX).offset(-10)
        }
        
        
        btnContinue.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(65)
            make.left.equalTo(btnNo.snp.right).offset(20)
        }
        
        
        btnContinue.setTitle("Yes", for: .normal)
 
        enableButton()
     
        scrollView.isHidden = true
        progressView?.isHidden = true
        
    }
    

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .statement(let title, let statement, let image):
            titleLabel.text = title.changeUsername()
            subtitleLabel.text = statement.changeUsername()
            imageView.image = image
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
            backgroundView.animate(type: .fadeInAndSlideInLeft, delay: 1)
            btnContinue.animate(type: .fadeInAndSlideInBottom, delay: 1.5)
            btnNo.animate(type: .fadeInAndSlideInBottom, delay: 1.5)
        }
    }
    
    

}
