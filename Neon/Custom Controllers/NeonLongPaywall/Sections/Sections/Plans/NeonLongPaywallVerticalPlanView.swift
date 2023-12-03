//
//  NeonLongPaywallVerticlPlanView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 23.11.2023.
//

import Foundation
import NeonSDK
import UIKit
import StoreKit


@available(iOS 15.0, *)
class NeonLongPaywallVerticalPlanView : UIView, AdaptyManagerDelegate{
    
    let manager = NeonLongPaywallPlanManager()
    let unitCostLabel = UILabel()
    let durationLabel = UILabel()
    let saveLabel = UILabel()
    let tagLabel = NeonPaddingLabel()
    
    var allPlans = [NeonLongPaywallPlan]()
    var plan : NeonLongPaywallPlan? = nil{
        didSet{
            packageFetched()
            manager.calculateSaveLabel(saveLabel: saveLabel)
            manager.calculateTagLabel(tagLabel: tagLabel)
            if manager.isDefaultPlan(){
                selectPlan()
            }
        }
    }
    
    let iconSelected = UIImageView()
    
    var delegate : NeonLongPaywallPlanViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configureView()
       
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func reloadPackage(){
        packageFetched()
        manager.calculateSaveLabel(saveLabel: saveLabel)
        manager.calculateTagLabel(tagLabel: tagLabel)
        if manager.isDefaultPlan(){
            selectPlan()
        }
    }
    
    func configureView(){
        
        
     
        layer.cornerRadius = NeonLongPaywallConstants.cornerRadius
        backgroundColor = NeonLongPaywallConstants.containerColor
        layer.borderColor = NeonLongPaywallConstants.containerBorderColor.cgColor
        layer.borderWidth = NeonLongPaywallConstants.containerBorderWidth
        isUserInteractionEnabled = true
        
        
       
        
        
        durationLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        durationLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        durationLabel.numberOfLines = 0
        durationLabel.textAlignment = .center
        addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(12)
        }
        
        
        tagLabel.textColor = NeonLongPaywallConstants.ctaButtonTextColor
        tagLabel.font = Font.custom(size: 13, fontWeight: .Bold)
        tagLabel.numberOfLines = 0
        tagLabel.textAlignment = .center
        tagLabel.layer.cornerRadius = 4
        tagLabel.layer.masksToBounds = true
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(durationLabel.snp.right).offset(10)
            make.centerY.equalTo(durationLabel)
        }
        tagLabel.leftInset = 6
        tagLabel.rightInset = 6
        tagLabel.topInset = 2
        tagLabel.bottomInset = 2
        
      
        
        unitCostLabel.text = "..."
        unitCostLabel.textColor = NeonLongPaywallConstants.primaryTextColor
        unitCostLabel.font = Font.custom(size: 12, fontWeight: .Medium)
        unitCostLabel.numberOfLines = 0
        unitCostLabel.textAlignment = .center
        addSubview(unitCostLabel)
        unitCostLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(durationLabel.snp.bottom).offset(5)
        }
        
        
        saveLabel.text = " "
        saveLabel.textColor = NeonLongPaywallConstants.mainColor
        saveLabel.font = Font.custom(size: 12, fontWeight: .SemiBold)
        saveLabel.numberOfLines = 0
        saveLabel.textAlignment = .center
        addSubview(saveLabel)
        saveLabel.snp.makeConstraints { make in
            make.left.equalTo(unitCostLabel.snp.right).offset(10)
            make.centerY.equalTo(unitCostLabel)
        }
        
        iconSelected.image = UIImage(named: "btn_radio_unselected")
        iconSelected.tintColor = NeonLongPaywallConstants.mainColor
        addSubview(iconSelected)
        iconSelected.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(planClicked))
        addGestureRecognizer(recognizer)
        
    }
    
    
    @objc func planClicked(){
        selectPlan()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    @objc func selectPlan(){
        
        guard let plan else { return }
        if NeonLongPaywallConstants.selectedPlan.productIdentifier != plan.productIdentifier{
            NeonLongPaywallConstants.selectedPlan = plan
        }
        
        if let delegate{
            delegate.planSelected()
        }
        
        if tagLabel.text != " "{
            tagLabel.backgroundColor = NeonLongPaywallConstants.mainColor
            tagLabel.textColor = NeonLongPaywallConstants.ctaButtonTextColor
        }
        
        
        backgroundColor = NeonLongPaywallConstants.selectedContainerColor
        layer.borderColor = NeonLongPaywallConstants.selectedContainerBorderColor.cgColor
        iconSelected.image = UIImage(named: "btn_radio_selected")
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    @objc func deselectPlan(){
        tagLabel.backgroundColor = .clear
        tagLabel.textColor = NeonLongPaywallConstants.mainColor
        
        backgroundColor = NeonLongPaywallConstants.containerColor
        layer.borderColor = NeonLongPaywallConstants.containerBorderColor.cgColor
        iconSelected.image = UIImage(named: "btn_radio_unselected")
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        }
    }
    

    func packageFetched() {
        
        guard let plan else { return }
        
        if let product = manager.fetchProduct(for: plan){
            manager.configurePriceWithProduct(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel, plan: plan, allPlans: allPlans)
        }else{
            // Couldn't fetch product
        }
    }

}
