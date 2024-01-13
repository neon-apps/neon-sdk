//
//  HorizontalPlanView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 20.11.2023.
//


import Foundation
import NeonSDK
import UIKit
import StoreKit


@available(iOS 15.0, *)
class NeonLongPaywallHorizontalPlanView : UIStackView, AdaptyManagerDelegate{
    
    let planManager = NeonLongPaywallPlanManager()
    var paywallManager = NeonLongPaywallManager()
    let unitCostLabel = UILabel()
    let durationLabel = UILabel()
    let saveLabel = UILabel()
    let tagLabel = NeonPaddingLabel()
    
    var allPlans = [NeonLongPaywallPlan]()
    var plan : NeonLongPaywallPlan? = nil{
        didSet{
            packageFetched()
            planManager.calculateSaveLabel(saveLabel: saveLabel)
            planManager.calculateTagLabel(tagLabel: tagLabel)
            if planManager.isDefaultPlan(){
                selectPlan()
            }
        }
    }
    let iconSelected = UIImageView()
    
    var delegate : NeonLongPaywallPlanViewDelegate?
    
    init(paywallManager : NeonLongPaywallManager) {
        super.init(frame: .zero)
        self.paywallManager = paywallManager
        configureView()
       
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadPackage(){
        packageFetched()
        planManager.calculateSaveLabel(saveLabel: saveLabel)
        planManager.calculateTagLabel(tagLabel: tagLabel)
        if planManager.isDefaultPlan(){
            selectPlan()
        }
    }
    
    func configureView(){
        
        
        axis = .vertical
        spacing = 10
        distribution = .fillProportionally
        alignment = .center
        layer.cornerRadius = paywallManager.constants.cornerRadius
        backgroundColor = paywallManager.constants.containerColor
        layer.borderColor = paywallManager.constants.containerBorderColor.cgColor
        layer.borderWidth = paywallManager.constants.containerBorderWidth
        isUserInteractionEnabled = true
        
        
        addSpacer(15)
        
        
        
        tagLabel.textColor = paywallManager.constants.ctaButtonTextColor
        tagLabel.font = Font.custom(size: 10, fontWeight: .Bold)
        tagLabel.numberOfLines = 0
        tagLabel.textAlignment = .center
        tagLabel.layer.cornerRadius = 4
        tagLabel.layer.masksToBounds = true
        addArrangedSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().inset(5)
        }
        tagLabel.leftInset = 6
        tagLabel.rightInset = 6
        tagLabel.topInset = 2
        tagLabel.bottomInset = 2
        
        
        durationLabel.textColor = paywallManager.constants.primaryTextColor
        durationLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        durationLabel.numberOfLines = 0
        durationLabel.textAlignment = .center
        addArrangedSubview(durationLabel)
        setCustomSpacing(3, after: durationLabel)
        
        
        
        unitCostLabel.text = "..."
        unitCostLabel.textColor = paywallManager.constants.primaryTextColor
        unitCostLabel.font = Font.custom(size: 10, fontWeight: .Medium)
        unitCostLabel.numberOfLines = 0
        unitCostLabel.textAlignment = .center
        addArrangedSubview(unitCostLabel)
        
        
        saveLabel.text = " "
        saveLabel.textColor = paywallManager.constants.mainColor
        saveLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        saveLabel.numberOfLines = 0
        saveLabel.textAlignment = .center
        addArrangedSubview(saveLabel)
        
        
        iconSelected.image =  UIImage(named: "btn_radio_unselected", in: Bundle.module, compatibleWith: nil)
        iconSelected.tintColor = paywallManager.constants.mainColor
        addArrangedSubview(iconSelected)
        iconSelected.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        addSpacer(15)
        
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
        
        if paywallManager.constants.selectedPlan.productIdentifier != plan.productIdentifier{
            paywallManager.constants.selectedPlan = plan
        }
     
        
        if let delegate{
            delegate.planSelected()
        }
        
        if tagLabel.text != " "{
            tagLabel.backgroundColor = paywallManager.constants.mainColor
            tagLabel.textColor = paywallManager.constants.ctaButtonTextColor
        }
        
        
        backgroundColor = paywallManager.constants.selectedContainerColor
        layer.borderColor = paywallManager.constants.selectedContainerBorderColor.cgColor
        iconSelected.image = UIImage(named: "btn_radio_selected", in: Bundle.module, compatibleWith: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    @objc func deselectPlan(){
        tagLabel.backgroundColor = .clear
        tagLabel.textColor = paywallManager.constants.mainColor
        
        backgroundColor = paywallManager.constants.containerColor
        layer.borderColor = paywallManager.constants.containerBorderColor.cgColor
        iconSelected.image = UIImage(named: "btn_radio_unselected", in: Bundle.module, compatibleWith: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        }
    }
    

    func packageFetched() {
        
        guard let plan else { return }
        
        if let product = planManager.fetchProduct(for: plan){
            planManager.configurePriceWithProduct(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel, plan: plan, allPlans: allPlans)
        }else{
            // Couldn't fetch product
        }
    }

}
