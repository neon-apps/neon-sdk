//
//  NeonLongOnboardingContractPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK
import AudioToolbox

@available(iOS 13.0, *)
class NeonLongOnboardingContractPage: BaseNeonLongOnboardingPage{
    var vibrationTimer: Timer?
    let itemsView = NeonLongOnboardingCustomPlanItemsView()
    let longPressAnimationView = NeonAnimationView(animation: .sdk(name: "longPress"), color: NeonLongOnboardingConstants.selectedOptionBorderColor)
    var longPressLabel = UILabel()
    let viewFingerPrint = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    override func createUI(){
        super.createUI()
        configurePage()
        
       
        titleLabel.font = Font.custom(size: 40, fontWeight: .SemiBold)
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(backButton.snp.bottom).offset(20)
        }
        
        subtitleLabel.font = Font.custom(size: 30, fontWeight: .SemiBold)
        subtitleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
     
        contentView.addSubview(itemsView)
        itemsView.verticalSpacing = 20
        itemsView.textSize = 18
        itemsView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
        }
        
        
        
     
        view.addSubview(longPressAnimationView)
        longPressAnimationView.lottieAnimationView.animationSpeed = 0.5
        longPressAnimationView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(30)
            make.width.height.equalTo(400)
            make.centerX.equalToSuperview()
        }
        longPressAnimationView.alpha = 0
        longPressAnimationView.lottieAnimationView.pause()
        addRecognizers()
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
       
        viewFingerPrint.layer.cornerRadius = 50
        viewFingerPrint.layer.masksToBounds = true
        viewFingerPrint.backgroundColor = NeonLongOnboardingConstants.selectedOptionBorderColor
        view.addSubview(viewFingerPrint)
        viewFingerPrint.snp.makeConstraints { make in
            make.center.equalTo(longPressAnimationView)
            make.width.height.equalTo(100)
        }
        viewFingerPrint.isUserInteractionEnabled = false
        
        let imgFingerPrint = UIImageView()
        imgFingerPrint.image = UIImage(named: "fingerPrint", in: Bundle.module, compatibleWith: nil)
        viewFingerPrint.addSubview(imgFingerPrint)
        imgFingerPrint.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
       
        longPressLabel.text = "Long press to confirm"
        longPressLabel.font = Font.custom(size: 16, fontWeight: .SemiBold)
        longPressLabel.textColor = NeonLongOnboardingConstants.textColor
        longPressLabel.textAlignment = .center
        view.addSubview(longPressLabel)
        longPressLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
     
        hideButton()
        progressView?.isHidden = true
        
      
        
    }
    

    func configurePage(){
        switch NeonLongOnboardingConstants.currentPage?.type {
        case .contract(let emoji, let title, let items):
            titleLabel.text = emoji
            subtitleLabel.text = title.changeUsername()
            itemsView.items = items

        break
        default:
            fatalError("Something went wrong with NeonLongOnboarding. Please consult to manager.")
        }
    }
    
    func addRecognizers(){
        longPressAnimationView.isUserInteractionEnabled = true
      
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.view.addGestureRecognizer(longPressGesture)
        
    
    }
    
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            longPressAnimationView.lottieAnimationView.play()
            startVibrationTimer()
            longPressAnimationView.animate(type: .fadeIn, duration: 1, delay: 0)
        case .ended, .cancelled:
            longPressAnimationView.lottieAnimationView.pause()
            stopVibrations()
            longPressAnimationView.animate(type: .fadeOut, duration: 1, delay: 0)
        default:
            break
        }
    }
    
    func startVibrationTimer() {
        
            stopVibrations() // Ensures any existing timer is stopped before starting a new one
       
        
            self.softVibrate()
            var seconds = 0
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
                seconds += 1
                switch seconds {
                case 8:
                    vibrate(style: .soft)
                case 16:
                    vibrate(style: .medium)
                case 24:
                    vibrate(style: .heavy)
                case 32:
                    hardVibrate()
                    stopVibrations()
                    NeonLongOnboardingManager.moveToNextPage(controller: self)
                default:
                    break
                }
            }
        }

        func stopVibrations() {
            vibrationTimer?.invalidate()
            vibrationTimer = nil
        }

        func hardVibrate() {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // Hard vibration
        }

        func softVibrate() {
            let softVibration = SystemSoundID(1519) // Soft vibration (UIFeedbackType)
            AudioServicesPlaySystemSound(softVibration)
        }
    
    
    override func animateViews() {
        if !isViewsAnimated{
            super.animateViews()
            isViewsAnimated = true
            subtitleLabel.animate(type: .fadeInAndSlideInLeft, delay: 1.2)
            viewFingerPrint.animate(type: .fadeIn, delay: 1.8)
            longPressLabel.animate(type: .fadeIn, delay: 2.0)
            itemsView.animate()
        }
    }
    
    

}

