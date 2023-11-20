//
//  NeonLongOnboardingTestimonialPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 15.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingTestimonialPage: BaseNeonLongOnboardingPage{
  
    var animationDelay = 1.2
    let descriptionLabel = UILabel()
    let firstTestimonialStack = UIStackView()
    let secondTestimonialStack = UIStackView()
    let peopleImageView = UIImageView()
    var isTestimonialsAdded = false
    var isTimerStarted = false
    var processingAnimationView : NeonAnimationView?
    var processingDuration = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
        adjustUIIfProcessDone()
    }
    override func createUI(){
        super.createUI()
        configurePage()
        
      
        processingAnimationView = NeonAnimationView(animation: .sdk(name: "processing"), color: NeonLongOnboardingConstants.selectedOptionBorderColor)
        view.addSubview(processingAnimationView!)
        processingAnimationView!.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top)
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        processingAnimationView?.lottieAnimationView.loopMode = .playOnce
        processingAnimationView?.lottieAnimationView.animationSpeed = CGFloat(10) / processingDuration
        processingAnimationView?.lottieAnimationView.pause()
        let processingLabel = UILabel()
        processingLabel.text = "0%"
        processingLabel.textColor = NeonLongOnboardingConstants.textColor
        processingLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        processingLabel.textAlignment = .center
        processingAnimationView!.addSubview(processingLabel)

        processingLabel.snp.makeConstraints { make in
            make.center.equalTo(processingAnimationView!)
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
            animateProcessingLabel(processingLabel, duration: TimeInterval(processingDuration))
            processingAnimationView?.lottieAnimationView.play()
            
        })
       
        
        titleLabel.removeFromSuperview()
        titleLabel.textAlignment = .center
        titleLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(processingAnimationView!.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.removeFromSuperview()
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = NeonLongOnboardingConstants.selectedOptionBorderColor
        subtitleLabel.font = Font.custom(size: 30, fontWeight: .Bold)
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
     
        
        
        descriptionLabel.font = Font.custom(size: 20, fontWeight: .SemiBold)
        descriptionLabel.textColor = NeonLongOnboardingConstants.textColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
        }
        
      
        
        
        
        firstTestimonialStack.axis = .horizontal
        firstTestimonialStack.spacing = 20
        firstTestimonialStack.distribution = .equalSpacing
        view.addSubview(firstTestimonialStack)
        firstTestimonialStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(180)
            make.left.equalToSuperview().offset(-50)
            make.width.equalTo(1900)
        }
        animateStack(stack: firstTestimonialStack, toLeft: true)
        
        secondTestimonialStack.axis = .horizontal
        secondTestimonialStack.spacing = 20
        secondTestimonialStack.distribution = .equalSpacing
        view.addSubview(secondTestimonialStack)
        secondTestimonialStack.snp.makeConstraints { make in
            make.bottom.equalTo(firstTestimonialStack.snp.top).offset(-20)
            make.height.equalTo(180)
            make.right.equalToSuperview().offset(50)
            make.width.equalTo(1900)
        }
        animateStack(stack: secondTestimonialStack, toLeft: false)
        
        if NeonDeviceManager.isCurrentDeviceEqualOrSmallerThan(.iPhone8){
            secondTestimonialStack.isHidden = true
        }
        
        peopleImageView.image = UIImage(named: "img_people_happy", in: Bundle.module, compatibleWith: nil)
        view.addSubview(peopleImageView)
        peopleImageView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(100)
            make.left.right.equalToSuperview()
        }
        


        view.addSubview(btnContinue)
        btnContinue.alpha = 1
        
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnContinue.snp.top).offset(-20)
        }
        
        progressView?.isHidden = true
     
       
    }
  
    func adjustUIIfProcessDone(){
        if isTimerStarted{
            backButton.isHidden = false
            btnContinue.isHidden = false
        }else{
            backButton.isHidden = true
            btnContinue.isHidden = true
        }
    }
  
        func animateProcessingLabel(_ label: UILabel, duration: TimeInterval) {
            if isTimerStarted{
                return
            }
            isTimerStarted = true
            var currentPercentage = 0
            Timer.scheduledTimer(withTimeInterval: duration / 100, repeats: true) { timer in
                currentPercentage += 1
                if currentPercentage <= 100 {
                    label.text = "\(currentPercentage)%"
                } else {
                    timer.invalidate()
                    self.btnContinueClicked()
                }
            }
        }
    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .testimonial(let firstTitle, let firstSubtitle, let processingDuration, let processingTitle, let testimonials):
            
            self.processingDuration = processingDuration
            titleLabel.text = processingTitle.changeUsername()
            subtitleLabel.text = firstTitle.changeUsername()
            descriptionLabel.text = firstSubtitle.changeUsername()
            
            if !isTestimonialsAdded{
                addTestimonials(testimonials: testimonials)
            }
           
           
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    

    func animateStack(stack : UIStackView, toLeft : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [self] in
            
            stack.snp.updateConstraints { make in
                if toLeft{
                    make.left.equalToSuperview().offset(-1900)
                }else{
                    make.right.equalToSuperview().offset(1900)
                }
            }
            UIView.animate(withDuration: 40, delay: 0, options: .curveLinear , animations: {
                self.view.layoutIfNeeded()
            })
     
        })
    }
    
    func addTestimonials(testimonials : [NeonTestimonial]){
        isTestimonialsAdded = true
        for testimonial in testimonials {
            let testimonialView = NeonLongOnboardingTestimonialView()
            testimonialView.configure(with: testimonial)
            firstTestimonialStack.addArrangedSubview(testimonialView)
            testimonialView.snp.makeConstraints { make in
                make.width.equalTo(300)
                make.height.equalToSuperview()
            }
            
            
        }
        
        for testimonial in testimonials {
            let testimonialView = NeonLongOnboardingTestimonialView()
            testimonialView.configure(with: testimonial)
            secondTestimonialStack.addArrangedSubview(testimonialView)
            testimonialView.snp.makeConstraints { make in
                make.width.equalTo(300)
                make.height.equalToSuperview()
            }
        }
      
    }
    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        NeonLongOnboardingManager.moveToNextPage(controller: self)
    }
    
    
    override func animateViews() {
        if !isViewsAnimated{
            isViewsAnimated = true
         
            subtitleLabel.animate(type: .fadeInAndSlideInLeft, delay: 0.5)
            descriptionLabel.animate(type: .fadeInAndSlideInLeft, delay: 1)
            
            processingAnimationView!.animate(type: .fadeInAndSlideInLeft, delay: 2)
            titleLabel.animate(type: .fadeInAndSlideInLeft, delay: 2)
            
            secondTestimonialStack.animate(type: .fadeIn, duration: 1, delay: 2.5)
            firstTestimonialStack.animate(type: .fadeIn, duration: 1, delay: 2.75)
            peopleImageView.animate(type: .fadeInAndSlideInBottom, delay: 3)
          
        }
    }
    
    

}

