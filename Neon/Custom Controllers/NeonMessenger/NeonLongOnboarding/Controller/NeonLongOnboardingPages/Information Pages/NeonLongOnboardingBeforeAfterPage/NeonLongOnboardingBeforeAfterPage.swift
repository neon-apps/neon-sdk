//
//  NeonLongOnboardingBeforeAfterPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingBeforeAfterPage: BaseNeonLongOnboardingPage{
  
    var afterView : BeforeAfterView?
    var beforeView : BeforeAfterView?
    
    let arrowImage = UIImageView()
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    
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
        configureBeforeAfterViews()
      
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(backButton.snp.bottom).offset(20)
        }
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
   
        
    
      
        
    }
    
    
    func setupBeforeAfterViews(beforeItems: [String], afterItems: [String]){
        
        
        afterView = BeforeAfterView(type: .after, title: "After", items: afterItems)
        afterView!.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.89, alpha: 1)
        contentView.addSubview(afterView!)
        afterView!.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(contentView.snp.centerX).offset(-20)
            make.bottom.equalTo(afterView!.stackView.snp.bottom).offset(40)
        }
        
       
        
        
        beforeView = BeforeAfterView(type: .before, title: "Before", items: beforeItems)
        beforeView!.backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        beforeView!.layer.borderColor = NeonLongOnboardingConstants.selectedOptionBorderColor.cgColor
        beforeView!.layer.borderWidth = 1
        contentView.addSubview(beforeView!)
        beforeView!.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(afterView!.snp.left).inset(20)
            make.bottom.equalTo(beforeView!.stackView.snp.bottom).offset(40)
        }
        contentView.bringSubviewToFront(afterView!)
        
      
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.tintColor = NeonLongOnboardingConstants.textColor
        view.addSubview(arrowImage)
        arrowImage.image = NeonSymbols.arrow_turn_up_right
        arrowImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(afterView!.snp.centerY)
            make.centerX.equalTo(afterView!.snp.left).offset(5)
            
        }
        
        
    }
    func configurePage(){
        progressView?.isHidden = true
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .beforeAfter(let title, let subtitle, _, _):
            titleLabel.text = title.changeUsername()
            subtitleLabel.text = subtitle.changeUsername()
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    func configureBeforeAfterViews(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .beforeAfter(_, _, let beforeItems, let afterItems):
            setupBeforeAfterViews(beforeItems: beforeItems, afterItems: afterItems)
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
            animationDelay += 0.5
            descriptionLabel.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            arrowImage.animate(type: .fadeIn, delay: animationDelay)
            animationDelay += 1
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            afterView!.animate(type: .slideInRight, delay: 1)
            beforeView!.animate(type: .slideInLeft, delay: 1)
        }
    }
    
    

}
