//
//  NeonLongPaywallPaymentSheetController.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 23.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
public class NeonLongPaywallPaymentSheetController : UIViewController{

    let planManager = NeonLongPaywallPlanManager()
    let continueButton = NeonBouncingButton()
    let saveLabel = UILabel()
    let unitCostLabel = UILabel()
    let tagLabel = NeonPaddingLabel()
    let durationLabel = UILabel()
    let totalPriceLabel = UILabel()
    var trialDuration : Int?
    let legalView = NeonLegalView()
    var paywallManager = NeonLongPaywallManager()
    public override func viewDidLoad() {
        super.viewDidLoad()
       
     
        
        
        fetchSelectedPlanDetails()
        configureUI()
       
        
        
    }
    
    public override func viewDidLayoutSubviews() {
       configureDetent()
    }
    

    func configureUI(){
        view.backgroundColor = paywallManager.constants.backgroundColor
        
   
    
        let getPremiumLabel = UILabel()
        getPremiumLabel.text = "Get Premium"
        getPremiumLabel.textColor = paywallManager.constants.primaryTextColor
        getPremiumLabel.font = Font.custom(size: 20, fontWeight: .SemiBold)
        getPremiumLabel.numberOfLines = 0
        getPremiumLabel.textAlignment = .center
        view.addSubview(getPremiumLabel)
        getPremiumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalToSuperview().inset(40)
        }
      
        var lastViewFromTrialLine : UIView?
        if let trialDuration{
            lastViewFromTrialLine = addTrialLine(previousView: getPremiumLabel, trialDuration: trialDuration)
            continueButton.setTitle("Start my \(trialDuration)-day free trial", for: .normal)
        }else{
            continueButton.setTitle("Confirm", for: .normal)
        }
        
        let lastViewFromCostLine = addUnitCostLine(previousView: lastViewFromTrialLine ?? getPremiumLabel)
        let lastViewFromTotalLine = addTotalLine(previousView: lastViewFromCostLine)
      
        
        let lblMoneyBack = UILabel()
        lblMoneyBack.text = "6 MONTHS MONEY BACK GUARANTEE"
        lblMoneyBack.textColor = paywallManager.constants.primaryTextColor
        lblMoneyBack.font = Font.custom(size: 14, fontWeight: .Medium)
        lblMoneyBack.numberOfLines = 0
        lblMoneyBack.textAlignment = .center
        view.addSubview(lblMoneyBack)
        lblMoneyBack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalTo(lastViewFromTotalLine.snp.bottom).offset(30)
        }
        
        
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        continueButton.layer.cornerRadius = paywallManager.constants.cornerRadius
        continueButton.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
        continueButton.backgroundColor = paywallManager.constants.mainColor
        continueButton.addAction {
   
            
        }
     
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.height.equalTo(60)
            make.top.equalTo(lblMoneyBack.snp.bottom).offset(20)
        }
        
        
       
        legalView.restoreButtonClicked = { [self] in
            NeonLongPaywallPurchaseManager.restore(paywallManager: paywallManager, controller: self){ [self] in
                paywallManager.delegate?.restored(from: self)
            }
        }
        if let termsURL = paywallManager.constants.termsURL, let privacyURL = paywallManager.constants.privacyURL{
            legalView.termsURL = termsURL
            legalView.privacyURL = privacyURL
        }else{
            legalView.configureLegalController(onVC: self, backgroundColor: paywallManager.constants.backgroundColor, headerColor: paywallManager.constants.mainColor, titleColor: paywallManager.constants.ctaButtonTextColor, textColor: paywallManager.constants.primaryTextColor)
        }
        legalView.textColor = paywallManager.constants.primaryTextColor
        view.addSubview(legalView)
        legalView.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.height.equalTo(40)
        }
    }
  
    
    func configureDetent(){
        if let presentationController = presentationController as? UISheetPresentationController {
            if #available(iOS 16.0, *) {
                presentationController.detents = [.custom(resolver: { context in
                    return self.legalView.frame.maxY + 20
                })]
            } else {
                if NeonDeviceManager.isCurrentDeviceSmallerThan(.iPhoneX){
                    presentationController.detents = [.large()]
                }else{
                    presentationController.detents = [.medium()]
                }
              
            }
            presentationController.prefersGrabberVisible = true
            }
    }
    func addTrialLine(previousView : UIView, trialDuration : Int) -> UIView{
        let trialLabel  = UILabel()
        trialLabel.text = "\(trialDuration)-DAY FREE TRIAL"
        trialLabel.textColor = paywallManager.constants.primaryTextColor
        trialLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        trialLabel.numberOfLines = 0
        trialLabel.textAlignment = .center
        view.addSubview(trialLabel)
        trialLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalTo(previousView.snp.bottom).offset(20)
        }
        
        let lblPremium = NeonPaddingLabel()
        lblPremium.text = "NO PAYMENT NOW"
        lblPremium.textColor = paywallManager.constants.mainColor
        lblPremium.font = Font.custom(size: 13, fontWeight: .Bold)
        lblPremium.numberOfLines = 0
        lblPremium.textAlignment = .center
        lblPremium.layer.cornerRadius = 4
        lblPremium.layer.masksToBounds = true
        view.addSubview(lblPremium)
        lblPremium.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.centerY.equalTo(trialLabel)
        }

        

        let lineView = UIView()
        lineView.backgroundColor = paywallManager.constants.primaryTextColor
        view.addSubview(lineView)
        lineView.alpha = 0.4
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalTo(trialLabel.snp.bottom).offset(20)
        }
        return lineView
        
        
    }
    
    func addUnitCostLine(previousView : UIView) -> UIView{
        durationLabel.textColor = paywallManager.constants.primaryTextColor
        durationLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        durationLabel.numberOfLines = 0
        durationLabel.textAlignment = .center
        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalTo(previousView.snp.bottom).offset(20)
        }
        
        let lblPremium = NeonPaddingLabel()
        lblPremium.text = "PRO"
        lblPremium.backgroundColor = paywallManager.constants.mainColor
        lblPremium.textColor = paywallManager.constants.ctaButtonTextColor
        lblPremium.font = Font.custom(size: 13, fontWeight: .Bold)
        lblPremium.numberOfLines = 0
        lblPremium.textAlignment = .center
        lblPremium.layer.cornerRadius = 4
        lblPremium.layer.masksToBounds = true
        view.addSubview(lblPremium)
        lblPremium.snp.makeConstraints { make in
            make.left.equalTo(durationLabel.snp.right).offset(10)
            make.centerY.equalTo(durationLabel)
        }
        lblPremium.leftInset = 6
        lblPremium.rightInset = 6
        lblPremium.topInset = 2
        lblPremium.bottomInset = 2
        
        unitCostLabel.textColor = paywallManager.constants.primaryTextColor
        unitCostLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        unitCostLabel.numberOfLines = 0
        unitCostLabel.textAlignment = .center
        view.addSubview(unitCostLabel)
        unitCostLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.centerY.equalTo(durationLabel)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = paywallManager.constants.primaryTextColor
        view.addSubview(lineView)
        lineView.alpha = 0.4
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalTo(unitCostLabel.snp.bottom).offset(20)
        }
        return lineView
        
        
    }
    func addTotalLine(previousView : UIView) -> UIView{
        
        
        let totalLabel = UILabel()
        totalLabel.text = "Total"
        totalLabel.textColor = paywallManager.constants.primaryTextColor
        totalLabel.font = Font.custom(size: 15, fontWeight: .Medium)
        totalLabel.numberOfLines = 0
        totalLabel.textAlignment = .center
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.top.equalTo(previousView.snp.bottom).offset(20)
        }
        
      
       
        totalPriceLabel.textColor = paywallManager.constants.primaryTextColor
        totalPriceLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        totalPriceLabel.numberOfLines = 0
        totalPriceLabel.textAlignment = .center
        view.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(paywallManager.constants.horizontalPadding)
            make.centerY.equalTo(totalLabel)
        }
        
        
       
      
        saveLabel.text = " "
        saveLabel.textColor = paywallManager.constants.mainColor
        saveLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        saveLabel.numberOfLines = 0
        saveLabel.textAlignment = .right
        view.addSubview(saveLabel)
        saveLabel.snp.makeConstraints { make in
            make.right.equalTo(totalPriceLabel.snp.left).offset(-15)
            make.centerY.equalTo(totalPriceLabel)
        }
        
        return saveLabel

    }
    
    
    @objc func continueButtonClicked(){
        
        vibrate(style: .heavy)
        NeonLongPaywallPurchaseManager.subscribe(paywallManager: paywallManager) { [self] in
            paywallManager.delegate?.purchased(from: self, identifier: paywallManager.constants.selectedPlan.productIdentifier)
        }
    }
    
    func fetchSelectedPlanDetails(){
        if let product = planManager.fetchProduct(for: paywallManager.constants.selectedPlan){
            planManager.configurePriceWithProduct(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel, plan: paywallManager.constants.selectedPlan, allPlans: paywallManager.constants.allPlans)
            planManager.calculateSaveLabel(saveLabel: saveLabel)
            planManager.calculateTagLabel(tagLabel: tagLabel)
            totalPriceLabel.text = planManager.getDefaultPrice(product: product)
            trialDuration = planManager.getTrialDuration(product: product)
            
        }else{
            // Couldn't fetch product
        }
        
       
      
    }
    
}
