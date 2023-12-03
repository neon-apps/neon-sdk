//
//  NeonLongPaywallController.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import UIKit
import Adapty

@available(iOS 15.0, *)
public class NeonLongPaywallController : UIViewController{
    let scrollView = UIScrollView()
    let mainStack = UIStackView()
    let contentView = UIView()
    let label = UILabel()
    let gradientLayer = CAGradientLayer()
    let paywallBackgroundView = UIView()
    let legalView = NeonLegalView()
    let continueButton = NeonBouncingButton()
    let manager = NeonLongPaywallPlanManager()
    public override func viewDidLoad() {
        super.viewDidLoad()
       
      
        configureUI()
        addSections()
        setDelegates()
        packageFetched()
        configureNotifications()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        logPaywallView()
    }
    public override func viewDidLayoutSubviews() {
        if let lastSubview = mainStack.subviews.last{
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: lastSubview.frame.maxY + 150)
            contentView.frame.size = scrollView.contentSize
        }
        
        updateGradientLayerFrame(gradientLayer: gradientLayer, paywallBackgroundView: paywallBackgroundView)
        }
       
    func configureUI(){
        view.backgroundColor = NeonLongPaywallConstants.backgroundColor
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
      
        
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainStack)
        mainStack.spacing = 0
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
      
        }

       
        view.addSubview(continueButton)
        continueButton.layer.cornerRadius = NeonLongPaywallConstants.cornerRadius
        continueButton.backgroundColor = NeonLongPaywallConstants.mainColor
        continueButton.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
     
        
        
        view.addSubview(paywallBackgroundView)
        view.bringSubviewToFront(continueButton)
        paywallBackgroundView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(continueButton.snp.top).offset(-50)
        }
        addGradientToPaywallBackground()
        
        
        if !NeonLongPaywallConstants.isPaymentSheetActive{
            configureLegalView()
            continueButton.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
                make.height.equalTo(60)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            }
        }
     
        
        
    }
    
    
    func configureLegalView(){
        
        
        legalView.restoreButtonClicked = {
            NeonLongPaywallPurchaseManager.restore(controller: self){
                NeonLongPaywallManager.delegate?.restored(from: self)
            }
        }
        if let termsURL = NeonLongPaywallConstants.termsURL, let privacyURL = NeonLongPaywallConstants.privacyURL{
            legalView.termsURL = termsURL
            legalView.privacyURL = privacyURL
        }else{
            legalView.configureLegalController(onVC: self, backgroundColor: NeonLongPaywallConstants.backgroundColor, headerColor: NeonLongPaywallConstants.mainColor, titleColor: NeonLongPaywallConstants.ctaButtonTextColor, textColor: NeonLongPaywallConstants.primaryTextColor)
        }
        legalView.textColor = NeonLongPaywallConstants.primaryTextColor
        view.addSubview(legalView)
        legalView.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.height.equalTo(70)
        }
    }
    func addGradientToPaywallBackground() {
       
        gradientLayer.colors = [NeonLongPaywallConstants.backgroundColor.withAlphaComponent(0).cgColor, NeonLongPaywallConstants.backgroundColor.cgColor]
        gradientLayer.locations = [0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        paywallBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
      
    }


    @objc func continueButtonClicked(){
        
        vibrate(style: .heavy)
        if NeonLongPaywallConstants.isPaymentSheetActive{
            let paymentSheetController = NeonLongPaywallPaymentSheetController()
            self.present(paymentSheetController, animated: true, completion: nil)
        }else{
            NeonLongPaywallPurchaseManager.subscribe {
                NeonLongPaywallManager.delegate?.purchased(from: self, identifier:  NeonLongPaywallConstants.selectedPlan.productIdentifier)
            }
        }
       
    }
    func updateGradientLayerFrame(gradientLayer: CAGradientLayer, paywallBackgroundView: UIView) {
        gradientLayer.frame = paywallBackgroundView.bounds
    }
    func addSections(){

        let btnCross = UIButton()
        btnCross.tintColor = NeonLongPaywallConstants.primaryTextColor
        btnCross.setImage(NeonSymbols.xmark, for: .normal)
        btnCross.addAction {
            NeonLongPaywallManager.delegate?.dismissed(from: self)
        }
        scrollView.addSubview(btnCross)
        btnCross.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
        }
       
        
        for section in NeonLongPaywallManager.sections{
            mainStack.addArrangedSubview(section.view)
        }
        
        

    }
    
    func setDelegates(){
          AdaptyManager.delegate = self
          RevenueCatManager.delegate = self
    }
    
    func configureNotifications(){
        NeonNotificationCenter.observe(id: "plan_selected") {
            self.setPlanViews()
            self.fetchSelectedPlanDetails()
        }
    }
    
    func logPaywallView(){
        let provider = NeonLongPaywallConstants.provider
        
        switch provider {
        case .adapty(let placementID):
            if let paywall = AdaptyManager.getPaywall(placementID: placementID){
                Adapty.logShowPaywall(paywall)
            }
            break
        default :
            break
        }
    }
    func fetchSelectedPlanDetails(){
        if let product = manager.fetchProduct(for: NeonLongPaywallConstants.selectedPlan){
            if let  trialDuration = manager.getTrialDuration(product: product), trialDuration != 0{
                continueButton.setTitle("Start my \(trialDuration)-day free trial", for: .normal)
            }else{
                continueButton.setTitle("Continue", for: .normal)
            }
            
        }
      
    }
    func setPlanViews(){
        for section in mainStack.subviews{
            if let planView = section as? NeonLongPaywallPlansView{
                planView.select(plan: NeonLongPaywallConstants.selectedPlan)
            }
        }
  
    }
}
@available(iOS 15.0, *)
extension NeonLongPaywallController :  RevenueCatManagerDelegate, AdaptyManagerDelegate{
    public func packageFetched() {
        for section in mainStack.subviews{
            if let planSection = section as? NeonLongPaywallPlansView{
                planSection.packageFetched()
                fetchSelectedPlanDetails()
            }
        }
    }
}






