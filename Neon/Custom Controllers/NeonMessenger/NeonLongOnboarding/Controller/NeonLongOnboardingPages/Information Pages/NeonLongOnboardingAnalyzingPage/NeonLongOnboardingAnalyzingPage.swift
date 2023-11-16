//
//  NeonLongOnboardingAnalyzingPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 14.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingAnalyzingPage: BaseNeonLongOnboardingPage{
  
    var animationDelay = 1.2
    var startingDelay = 1.0
    var completedProgressCount = 0
    var sectionProcessDuration = Double()
    let descriptionLabel = UILabel()
    let mainStack = UIStackView()
    var processedTitle = String()
    var mainTitle = String()
    var isProcessCompleted = false
    var animationView = NeonAnimationView(animation: .loadingCircle2)
    let stackButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
        checkIfProcessCompleted()
    }
    override func createUI(){
        super.createUI()
        configurePage()
        configureProgessBars()
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(backButton.snp.bottom).offset(20)
        }
        
        progressView?.isHidden = true
        hideButton()
        
    }
    

    func configureProgessBars(){
        
        
        contentView.addSubview(mainStack)
        mainStack.spacing = 20
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview().inset(20)
        }
        
      
     
        mainStack.addArrangedSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
        }
        
        mainStack.setCustomSpacing(0, after: animationView)
        backButton.isHidden = true
        for section in NeonLongOnboardingConstants.sections{
            animationDelay += 0.2
            let analyzingPogressView = NeonLongOnboardingPageAnalyzingProgressView(
                completionDuration: TimeInterval(sectionProcessDuration),
                delay: startingDelay, onProgressComplete: { [self] in
                    completedProgressCount += 1
                    if completedProgressCount == NeonLongOnboardingConstants.sections.count{
                        processCompleted()
                    }
                }
            )
            analyzingPogressView.title = section.title
            contentView.addSubview(analyzingPogressView)
            analyzingPogressView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(40)
                make.height.equalTo(60)
            }
            
            mainStack.addArrangedSubview(analyzingPogressView)
            analyzingPogressView.animate(type: .fadeIn, delay: animationDelay)
            startingDelay += Double((sectionProcessDuration + 1))
        }
        
        mainStack.addArrangedSubview(UIView())
        mainStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        
        addStackButton()
        
        
    
    }
    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .analyzing(let title, let subtitle, let processedTitle, let animation,  let sectionProcessDuration):
            titleLabel.text = title.changeUsername()
            descriptionLabel.text = subtitle.changeUsername()
            animationView = animation
            self.mainTitle = title
            self.processedTitle = processedTitle
            self.sectionProcessDuration = sectionProcessDuration
        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    @objc override func btnContinueClicked(){
        super.btnContinueClicked()
        NeonLongOnboardingManager.moveToNextPage(controller: self)
    }
    
    
    func addStackButton(){
        mainStack.addArrangedSubview(stackButton)
        stackButton.layer.cornerRadius = 32.5
        stackButton.layer.masksToBounds = true
        stackButton.setTitle(btnContinue.titleLabel!.text, for: .normal)
        stackButton.titleLabel?.font = Font.custom(size: 18, fontWeight: .SemiBold)
        stackButton.backgroundColor = NeonLongOnboardingConstants.buttonColor
        stackButton.layer.borderWidth = 2
        stackButton.setTitleColor(NeonLongOnboardingConstants.buttonTextColor, for: .normal)
        stackButton.isHidden = true
        stackButton.addTarget(self, action: #selector(btnContinueClicked), for: .touchUpInside)
        stackButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(65)
        }
    }
    func checkIfProcessCompleted(){
        if isProcessCompleted{
            stackButton.isHidden = false
            backButton.isHidden = false
            titleLabel.text = processedTitle
        }else{
            stackButton.isHidden = true
            backButton.isHidden = true
            titleLabel.text = mainTitle
        }
    }
    func processCompleted(){
        isProcessCompleted = true
        
        self.titleLabel.text = processedTitle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animationView.animate(type: .fadeOut, duration: 0.5)
            
            UIView.animate(withDuration: 1.5, animations: {
                self.animationView.isHidden = true
                self.mainStack.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.btnContinueClicked()
            })
        })
    }
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            animationView.animate(type: .fadeInAndSlideInLeft, delay: 1)
            animationDelay += 0.5
            descriptionLabel.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
            btnContinue.animate(type: .fadeInAndSlideInLeft, delay: 1)
    
        }
    }
    
    

}
