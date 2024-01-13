//
//  NeonLongPaywallHorizontalPlansView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
public class NeonLongPaywallPlansView : BaseNeonLongPaywallSectionView, NeonLongPaywallPlanViewDelegate{
    
    

    
    
    let stackView = UIStackView()
    var type = NeonLongPaywallPlanViewType.horizontal
    
    public override func configureSection(type: NeonLongPaywallSectionType) {
        
      
       
    
        switch type {
        case .plans(let type, let plans):
            self.type = type
            manager.constants.allPlans = plans
            plans.forEach({addItem(item: $0, allItems: plans)})
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }

        packageFetched()
        configureView()
        setConstraint()
    }
    
    
    func configureView(){
        
      
        switch type {
        case .horizontal:
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                if manager.constants.allPlans.count < 3{
                    make.width.equalTo(manager.constants.allPlans.count * 130)
                    stackView.spacing = 20
                }else{
                    make.left.right.equalToSuperview()
                    stackView.spacing = 10
                }
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(170)
            }
            
        case .vertical:
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
            }
            
        }
    
    }
    
    func addItem(item : NeonLongPaywallPlan, allItems : [NeonLongPaywallPlan]){
        
        switch type {
        case .horizontal:
            let planView = NeonLongPaywallHorizontalPlanView(paywallManager: manager)
            planView.allPlans = allItems
            planView.plan = item
            planView.delegate = self
            stackView.addArrangedSubview(planView)
        case .vertical:
            let planView = NeonLongPaywallVerticalPlanView(paywallManager: manager)
            planView.allPlans = allItems
            planView.plan = item
            planView.delegate = self
            stackView.addArrangedSubview(planView)
            planView.snp.makeConstraints { make in
                make.bottom.equalTo(planView.unitCostLabel.snp.bottom).offset(12)
            }
        }
    }
    
    func planSelected() {
        deselectPlans()
    }
    
    func select(plan : NeonLongPaywallPlan){
        
        deselectPlans()
        
        for subview in stackView.subviews{
            switch type {
            case .horizontal:
                if let planView = subview as? NeonLongPaywallHorizontalPlanView{
                    if planView.plan?.productIdentifier == plan.productIdentifier{
                        planView.selectPlan()
                    }
                }
            case .vertical:
                if let planView = subview as? NeonLongPaywallVerticalPlanView{
                    if planView.plan?.productIdentifier == plan.productIdentifier{
                        planView.selectPlan()
                    }
                }
            }
        }
        
    }
    func deselectPlans(){
        for subview in stackView.subviews{
            switch type {
            case .horizontal:
                if let plan = subview as? NeonLongPaywallHorizontalPlanView{
                    plan.deselectPlan()
                }
            case .vertical:
                if let plan = subview as? NeonLongPaywallVerticalPlanView{
                    plan.deselectPlan()
                }
            }
        }
    }
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
        }
    }
    
    func packageFetched() {
        for subview in stackView.subviews{
            switch type {
            case .horizontal:
                if let plan = subview as? NeonLongPaywallHorizontalPlanView{
                    plan.reloadPackage()
                }
            case .vertical:
                if let plan = subview as? NeonLongPaywallVerticalPlanView{
                    plan.reloadPackage()
                }
            }
        }
    }
    
}
