//
//  NeonAdaptyPaywallVC.swift
//  neonApps-chatgpt
//
//  Created by Tuna Öztürk on 25.06.2023.
//

#if !os(xrOS)
import Foundation
import UIKit
import Adapty

@available(iOS 13.0, *)
public class NeonAdaptyPaywallVC : UIViewController, AdaptyManagerDelegate{

    let btnWeekly = NeonAdaptyPaywallButton()
    let btnLifetime = NeonAdaptyPaywallButton()
    let titleLabel = UILabel()
    let btnBuy = NeonBouncingButton()
    var completionAfterShowingPaywall : (() -> ())?
        
    public init(canDismiss : Bool = true){
        AdaptyPaywallBuilder.shared.canDismiss = canDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        AdaptyManager.selectedPaywall = AdaptyManager.getPaywall(id: AdaptyPaywallBuilder.shared.paywallID)
        createUI()
        packageFetched()
        Neon.onboardingCompleted()
        if let paywall = AdaptyManager.selectedPaywall{
            Adapty.logShowPaywall(paywall)
        }
    }
    
    func createUI(){

        let backgroundImage = UIImageView()
        backgroundImage.image = AdaptyPaywallBuilder.shared.backgroundImage
        backgroundImage.backgroundColor = AdaptyPaywallBuilder.shared.backgroundColor
        view.addSubview(backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.textAlignment = .center
        titleLabel.text = AdaptyPaywallBuilder().titleLabelTextWhenWeeklySelected
        titleLabel.numberOfLines = 2
        titleLabel.font = Font.custom(size: 30, fontWeight: .SemiBold)
        titleLabel.textColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            
        }
        
        createAnimatedViews()
        
        let testimonialView = NeonTestimonialView()
        view.addSubview(testimonialView)
        testimonialView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(210)
        }
        
    
        testimonialView.testimonialTextColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ?  .white : .black
        testimonialView.testimonialbackgroundColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ?  AdaptyPaywallBuilder.shared.darkColor : AdaptyPaywallBuilder.shared.lightColor
        testimonialView.currentTestimonialPageTintColor = AdaptyPaywallBuilder.shared.mainColor
        testimonialView.testimonialPageTintColor = .darkGray
        testimonialView.testimonialbackgroundCornerRadious = 12
        testimonialView.pageControlType = .V1
        
        testimonialView.addTestimonial(title: AdaptyPaywallBuilder.shared.testimonial1.title, testimonial: AdaptyPaywallBuilder.shared.testimonial1.testimonial, author: AdaptyPaywallBuilder.shared.testimonial1.author)
        testimonialView.addTestimonial(title: AdaptyPaywallBuilder.shared.testimonial2.title, testimonial: AdaptyPaywallBuilder.shared.testimonial2.testimonial, author: AdaptyPaywallBuilder.shared.testimonial2.author)
        testimonialView.addTestimonial(title: AdaptyPaywallBuilder.shared.testimonial3.title, testimonial: AdaptyPaywallBuilder.shared.testimonial3.testimonial, author: AdaptyPaywallBuilder.shared.testimonial3.author)

  
        let legalView = NeonLegalView()
        legalView.termsURL = AdaptyPaywallBuilder.shared.termsURL
        legalView.privacyURL = AdaptyPaywallBuilder.shared.privacyURL
        legalView.restoreButtonClicked = {
            AdaptyManager.restorePurchases(vc: self, animation: .loadingCircle, animationColor: AdaptyPaywallBuilder.shared.mainColor) {
                self.present(destinationVC: Neon.homeVC, slideDirection: .right)
            } completionFailure: {
                
            }
        }
        legalView.textColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        view.addSubview(legalView)
        legalView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
      
        btnBuy.setTitle(AdaptyPaywallBuilder().ctaButtonTextWhenWeeklySelected, for: .normal)
        btnBuy.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
        btnBuy.backgroundColor = AdaptyPaywallBuilder.shared.mainColor
        btnBuy.setTitleColor(.white, for: .normal)
        btnBuy.layer.cornerRadius = 12
        btnBuy.bouncingScale = AdaptyPaywallBuilder().ctaButtonBouncedScale
        btnBuy.bouncingDuration = AdaptyPaywallBuilder().ctaButtonBouncingDuration
        btnBuy.addTarget(self, action: #selector(btnBuyClicked), for: .touchUpInside)
        view.addSubview(btnBuy)
        btnBuy.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(legalView.snp.top).offset(0)
            make.height.equalTo(60)
        }
        
        let lblFreeTrial = UILabel()
        lblFreeTrial.textAlignment = .left
        lblFreeTrial.text = "Enable Free Trial".localized()
        lblFreeTrial.numberOfLines = 1
        lblFreeTrial.font = Font.custom(size: 15, fontWeight: .Medium)
        lblFreeTrial.textColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        view.addSubview(lblFreeTrial)
        lblFreeTrial.snp.makeConstraints { make in
            make.bottom.equalTo(btnBuy.snp.top).offset(-30)
            make.left.equalToSuperview().inset(40)
            
        }
        
        let switchFreeTrial = UISwitch()
        switchFreeTrial.isOn = true
        view.addSubview(switchFreeTrial)
        switchFreeTrial.addTarget(self, action: #selector(switchFreeTrialClicked(_ :)), for: .valueChanged)
        switchFreeTrial.snp.makeConstraints { make in
            make.centerY.equalTo(lblFreeTrial)
            make.right.equalToSuperview().inset(40)
            
        }
     
        btnLifetime.title = "Lifetime -".localized()
        btnLifetime.title = " \(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.lifetimeProductID)) "
        btnLifetime.title += "billed once".localized()
        btnLifetime.subtitle = "Unlock Premium Features".localized()
        view.addSubview(btnLifetime)
        btnLifetime.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(switchFreeTrial.snp.top).offset(-20)
            make.height.equalTo(65)
        }
        btnLifetime.clickCompletion = { [self] in
            AdaptyManager.selectPackage(id: AdaptyPaywallBuilder.shared.lifetimeProductID)
            titleLabel.text = AdaptyPaywallBuilder().titleLabelTextWhenLifetimeSelected
            btnBuy.setTitle(AdaptyPaywallBuilder().ctaButtonTextWhenLifetimeSelected, for: .normal)
            switchFreeTrial.setOn(false, animated: true)
        }
      
        btnWeekly.title = "\(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.weeklyProductID)) "
        btnWeekly.title += "per week".localized()
        btnWeekly.subtitle = "3-day free trial".localized()
        btnWeekly.isSelected = true
        view.addSubview(btnWeekly)
        btnWeekly.isBestSeller = true
        btnWeekly.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(btnLifetime.snp.top).offset(-20)
            make.height.equalTo(65)
        }
        btnWeekly.clickCompletion = { [self] in
            AdaptyManager.selectPackage(id: AdaptyPaywallBuilder.shared.weeklyProductID)
            titleLabel.text = AdaptyPaywallBuilder().titleLabelTextWhenWeeklySelected
            btnBuy.setTitle(AdaptyPaywallBuilder().ctaButtonTextWhenWeeklySelected, for: .normal)
            switchFreeTrial.setOn(true, animated: true)
        }
        
        
        let featuresView = NeonPaywallFeaturesView()
        featuresView.featureTextColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        featuresView.featureIconBackgroundColor = AdaptyPaywallBuilder.shared.mainColor
        featuresView.featureIconTintColor = .white
        view.addSubview(featuresView)
        featuresView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(testimonialView.snp.bottom).offset(5)
            make.bottom.equalTo(btnWeekly.snp.top).offset(-10)
        }
        featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature1!.title, icon: AdaptyPaywallBuilder.shared.feature1!.icon!)
        featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature2!.title, icon: AdaptyPaywallBuilder.shared.feature2!.icon!)
      
        if UIScreen.main.bounds.height > 812{ // iPhone X
            featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature3!.title, icon: AdaptyPaywallBuilder.shared.feature3!.icon!)
        }
       
        if UIScreen.main.bounds.height <= 667{ // iPhone 8
            featuresView.addFeature(title: AdaptyPaywallBuilder.shared.feature3!.title, icon: AdaptyPaywallBuilder.shared.feature3!.icon!)
            testimonialView.isHidden = true
            
            featuresView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.bottom.equalTo(btnWeekly.snp.top).offset(-10)
            }
        }
        
        createCloseButton()
    }
    
    @objc func btnBuyClicked(){
        if AdaptyManager.selectedPackage == nil{
            AdaptyManager.selectPackage(id: AdaptyPaywallBuilder.shared.weeklyProductID)
        }
        AdaptyManager.purchase(animation: .loadingCircle, animationColor: AdaptyPaywallBuilder.shared.mainColor) { [self] in
            if AdaptyPaywallBuilder.shared.canDismiss{
                dismiss(animated: true)
            }else{
                self.present(destinationVC: Neon.homeVC, slideDirection: .down)
            }
        } completionFailure: {
         
        }

    }
    func createAnimatedViews(){
        let sparkle1 = NeonAnimationView(animation: .sdk(name: "sparkle_1"), color: AdaptyPaywallBuilder.shared.mainColor)
        view.addSubview(sparkle1)
        sparkle1.alpha = 0.4
        sparkle1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(150)
            make.right.equalToSuperview().offset(10)
        }
        
        let sparkle2 = NeonAnimationView(animation: .sdk(name: "sparkle_2"), color: AdaptyPaywallBuilder.shared.mainColor)
        view.addSubview(sparkle2)
        sparkle2.alpha = 0.4
        sparkle2.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.width.height.equalTo(100)
            make.left.equalTo(titleLabel.snp.left).offset(-20)
        }
        
        let sparkle3 = NeonAnimationView(animation: .sdk(name: "sparkle_1"), color:  AdaptyPaywallBuilder.shared.mainColor)
        view.addSubview(sparkle3)
        sparkle3.alpha = 0.4
        sparkle3.transform = CGAffineTransform(scaleX: -1, y: 1)
        sparkle3.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.height.equalTo(150)
            make.right.equalTo(titleLabel.snp.right).offset(20)
        }
        
    }
    
    func createCloseButton(){
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        let closeButtonAlpha = AdaptyPaywallBuilder().closeButtonAlpha
        closeButton.alpha = closeButtonAlpha
        closeButton.tintColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? .white : .black
        closeButton.addAction { [self] in
            if AdaptyPaywallBuilder.shared.canDismiss{
    
                dismiss(animated: true)
                
                if let completionAfterShowingPaywall{
                    completionAfterShowingPaywall()
                }
      
            }else{
                present(destinationVC: Neon.homeVC, slideDirection: .right)
            }
        }
      
        let closeButtonAppearanceDuration = AdaptyPaywallBuilder().closeButtonAppearanceDuration
        if closeButtonAppearanceDuration != 0{
            closeButton.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + closeButtonAppearanceDuration , execute: {
            closeButton.isHidden = false
        })
        view.addSubview(closeButton)
        let closeButtonSize = AdaptyPaywallBuilder().closeButtonSize
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(closeButtonSize)
        }
        
        
    }
    @objc func switchFreeTrialClicked(_ sender : UISwitch ){
        if sender.isOn{
            btnWeekly.clicked()
        }else{
            btnLifetime.clicked()
        }
    }
    
    public func packageFetched() {
        btnLifetime.title = "Lifetime -".localized()
        btnLifetime.title = " \(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.lifetimeProductID)) "
        btnLifetime.title += "billed once".localized()
        
        btnWeekly.title = "\(AdaptyManager.getPackagePrice(id: AdaptyPaywallBuilder.shared.weeklyProductID)) "
        btnWeekly.title += "per week".localized()
    }
    
}
#endif
