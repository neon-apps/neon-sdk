//
//  NeonLongPaywallPaymentSheetController.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 23.11.2023.
//

import Foundation
import UIKit
import NeonSDK

public class NeonLongPaywallPaymentSheetController : UIViewController{

    let manager = NeonLongPaywallPlanManager()
    let continueButton = NeonBouncingButton()
    let saveLabel = UILabel()
    let unitCostLabel = UILabel()
    let tagLabel = NeonPaddingLabel()
    let durationLabel = UILabel()
    let totalPriceLabel = UILabel()
    var trialDuration : Int?
    let legalView = NeonLegalView()
    public override func viewDidLoad() {
        super.viewDidLoad()
       
     
        
        
        fetchSelectedPlanDetails()
        configureUI()
       
        
        
    }
    
    public override func viewDidLayoutSubviews() {
       configureDetent()
    }
    

    func configureUI(){
        view.backgroundColor = NeonLongPaywallConstants.backgroundColor
        
   
    
        let getPremiumLabel = UILabel()
        getPremiumLabel.text = "Get Premium"
        getPremiumLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        getPremiumLabel.font = Font.custom(size: 20, fontWeight: .SemiBold)
        getPremiumLabel.numberOfLines = 0
        getPremiumLabel.textAlignment = .center
        view.addSubview(getPremiumLabel)
        getPremiumLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
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
        lblMoneyBack.textColor = NeonLongPaywallConstants.primaryTextColor
        lblMoneyBack.font = Font.custom(size: 14, fontWeight: .Medium)
        lblMoneyBack.numberOfLines = 0
        lblMoneyBack.textAlignment = .center
        view.addSubview(lblMoneyBack)
        lblMoneyBack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.top.equalTo(lastViewFromTotalLine.snp.bottom).offset(30)
        }
        
        
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        continueButton.layer.cornerRadius = NeonLongPaywallConstants.cornerRadius
        continueButton.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
        continueButton.backgroundColor = NeonLongPaywallConstants.mainColor
        continueButton.addAction {
   
            
        }
     
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.height.equalTo(60)
            make.top.equalTo(lblMoneyBack.snp.bottom).offset(20)
        }
        
        
       
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
        trialLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        trialLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        trialLabel.numberOfLines = 0
        trialLabel.textAlignment = .center
        view.addSubview(trialLabel)
        trialLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.top.equalTo(previousView.snp.bottom).offset(20)
        }
        
        let lblPremium = NeonPaddingLabel()
        lblPremium.text = "NO PAYMENT NOW"
        lblPremium.textColor = NeonLongPaywallConstants.mainColor
        lblPremium.font = Font.custom(size: 13, fontWeight: .Bold)
        lblPremium.numberOfLines = 0
        lblPremium.textAlignment = .center
        lblPremium.layer.cornerRadius = 4
        lblPremium.layer.masksToBounds = true
        view.addSubview(lblPremium)
        lblPremium.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.centerY.equalTo(trialLabel)
        }

        

        let lineView = UIView()
        lineView.backgroundColor = NeonLongPaywallConstants.primaryTextColor
        view.addSubview(lineView)
        lineView.alpha = 0.4
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.top.equalTo(trialLabel.snp.bottom).offset(20)
        }
        return lineView
        
        
    }
    
    func addUnitCostLine(previousView : UIView) -> UIView{
        durationLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        durationLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        durationLabel.numberOfLines = 0
        durationLabel.textAlignment = .center
        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.top.equalTo(previousView.snp.bottom).offset(20)
        }
        
        let lblPremium = NeonPaddingLabel()
        lblPremium.text = "PRO"
        lblPremium.backgroundColor = NeonLongPaywallConstants.mainColor
        lblPremium.textColor = NeonLongPaywallConstants.ctaButtonTextColor
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
        
        unitCostLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        unitCostLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        unitCostLabel.numberOfLines = 0
        unitCostLabel.textAlignment = .center
        view.addSubview(unitCostLabel)
        unitCostLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.centerY.equalTo(durationLabel)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = NeonLongPaywallConstants.primaryTextColor
        view.addSubview(lineView)
        lineView.alpha = 0.4
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.top.equalTo(unitCostLabel.snp.bottom).offset(20)
        }
        return lineView
        
        
    }
    func addTotalLine(previousView : UIView) -> UIView{
        
        
        let totalLabel = UILabel()
        totalLabel.text = "Total"
        totalLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        totalLabel.font = Font.custom(size: 15, fontWeight: .Medium)
        totalLabel.numberOfLines = 0
        totalLabel.textAlignment = .center
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.top.equalTo(previousView.snp.bottom).offset(20)
        }
        
      
       
        totalPriceLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        totalPriceLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        totalPriceLabel.numberOfLines = 0
        totalPriceLabel.textAlignment = .center
        view.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(NeonLongPaywallConstants.horizontalPadding)
            make.centerY.equalTo(totalLabel)
        }
        
        
       
      
        saveLabel.text = " "
        saveLabel.textColor = NeonLongPaywallConstants.mainColor
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
        NeonLongPaywallPurchaseManager.subscribe {
            NeonLongPaywallManager.delegate?.purchased(from: self, identifier: NeonLongPaywallConstants.selectedPlan.productIdentifier)
        }
    }
    
    func fetchSelectedPlanDetails(){
        if let product = manager.fetchProduct(for: NeonLongPaywallConstants.selectedPlan){
            manager.configurePriceWithProduct(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel, plan: NeonLongPaywallConstants.selectedPlan, allPlans: NeonLongPaywallConstants.allPlans)
            manager.calculateSaveLabel(saveLabel: saveLabel)
            manager.calculateTagLabel(tagLabel: tagLabel)
            totalPriceLabel.text = manager.getDefaultPrice(product: product)
            trialDuration = manager.getTrialDuration(product: product)
            
        }else{
            // Couldn't fetch product
        }
        
       
      
    }
    
}
