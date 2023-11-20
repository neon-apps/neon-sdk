//
//  NeonLongOnboardingSayGoodbyePage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 13.11.2023.
//

import Foundation
import UIKit
import NeonSDK


@available(iOS 13.0, *)
class NeonLongOnboardingSayGoodbyePage: BaseNeonLongOnboardingPage{
  
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    let crossAnimation = NeonAnimationView(animation: .sdk(name: "cross"))
    let sayGoodbyeView1 = NeonLongOnboardingSayGoodbyeView()
    let sayGoodbyeView2 = NeonLongOnboardingSayGoodbyeView()
    let sayGoodbyeView3 = NeonLongOnboardingSayGoodbyeView()
    let sayGoodbyeView4 = NeonLongOnboardingSayGoodbyeView()
    
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
            make.height.equalTo(80)
        }
        
        sayGoodbyeView1.image = UIImage(named: "imgSayGoodbye-1", in: Bundle.module, compatibleWith: nil)
        sayGoodbyeView1.rotate(degree: -5)
        view.addSubview(sayGoodbyeView1)
        sayGoodbyeView1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(btnContinue.snp.top).offset(-40)
        }
        
        
        sayGoodbyeView2.image = UIImage(named: "imgSayGoodbye-2", in: Bundle.module, compatibleWith: nil)
        sayGoodbyeView2.rotate(degree: 5)
        view.addSubview(sayGoodbyeView2)
        sayGoodbyeView2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(btnContinue.snp.top).offset(-40)
        }
        
        
        sayGoodbyeView3.image = UIImage(named: "imgSayGoodbye-3", in: Bundle.module, compatibleWith: nil)
        sayGoodbyeView3.rotate(degree: -10)
        view.addSubview(sayGoodbyeView3)
        sayGoodbyeView3.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(btnContinue.snp.top).offset(-40)
        }
        
       
        sayGoodbyeView4.image = UIImage(named: "imgSayGoodbye-4", in: Bundle.module, compatibleWith: nil)
        sayGoodbyeView4.rotate(degree: 10)
        view.addSubview(sayGoodbyeView4)
        sayGoodbyeView4.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(75)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(btnContinue.snp.top).offset(-40)
        }
     
        view.addSubview(crossAnimation)
        crossAnimation.snp.makeConstraints { make in
            make.center.equalTo(sayGoodbyeView4)
            make.width.height.equalTo(400)
        }
        crossAnimation.lottieAnimationView.loopMode = .playOnce
        crossAnimation.lottieAnimationView.pause()
        
      
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
        progressView?.isHidden = true
        
    }
    

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .sayGoodbye(let title, let items):
            titleLabel.text = title.changeUsername()
            titleLabel.sizeToFit()
            if items.count != 4{
                fatalError("To use Say Goodbye page, you should add exactly 4 items.")
            }
            
            sayGoodbyeView1.labelText = items[0]
            sayGoodbyeView2.labelText = items[1]
            sayGoodbyeView3.labelText = items[2]
            sayGoodbyeView4.labelText = items[3]
  
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
            
            sayGoodbyeView1.animate(type: .fadeInAndSlideInLeft, delay: 1)
            sayGoodbyeView2.animate(type: .fadeInAndSlideInLeft, delay: 2)
            sayGoodbyeView3.animate(type: .fadeInAndSlideInLeft, delay: 3)
            sayGoodbyeView4.animate(type: .fadeInAndSlideInLeft, delay: 4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.crossAnimation.lottieAnimationView.play()
            })
            btnContinue.animate(type: .fadeInAndSlideInBottom, delay: 6)
        }
    }
    
    

}

