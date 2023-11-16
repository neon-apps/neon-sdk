//
//  BaseNeonLongOnboardingSelectionPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class BaseNeonLongOnboardingSelectionPage: BaseNeonLongOnboardingPage, NeonLongOnboardingPageOptionViewDelegate {
    
    
    let mainStack = UIStackView()
    let whyWeAskLabel = UIButton()
    var whyDoWeAskDescription = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePage()
    }
    override func createUI(){
        super.createUI()
        
        view.backgroundColor = NeonLongOnboardingConstants.pageBackgroundColor
        
        contentView.addSubview(mainStack)
        mainStack.spacing = 20
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(20)
        }
        
      
        whyWeAskLabel.setTitle("Why do we ask?", for: .normal)
        whyWeAskLabel.setTitleColor(NeonLongOnboardingConstants.textColor, for: .normal)
        whyWeAskLabel.titleLabel?.font = Font.custom(size: 16, fontWeight: .SemiBold)
        whyWeAskLabel.addUnderline()
        view.addSubview(whyWeAskLabel)
        if #available(iOS 13.0, *) {
            whyWeAskLabel.addTarget(self, action: #selector(whyWeAskLabelClicked), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
            whyWeAskLabel.isHidden = true
        }
        
        
        
    }
    
    @available(iOS 13.0, *)
    @objc func whyWeAskLabelClicked(){
        NeonAlertManager.custom.present(viewController: self, title: "Why do we ask?", message: whyDoWeAskDescription, icon: UIImage(named: "whyDoWeAskIcon", in: Bundle.module, compatibleWith: nil)!,buttons: [
            CustomAlertButton(title: "Got it!", buttonType: .background, overrideTextColor: NeonLongOnboardingConstants.buttonTextColor)
        ])
    }
    
    func getSelectedOptions() -> [String]{
        var selectedOptions = [String]()
        if let optionViews = mainStack.arrangedSubviews as? [NeonLongOnboardingPageOptionView]{
            for optionView in optionViews {
                if optionView.isSelected{
                    selectedOptions.append(optionView.titleLabel.text!)
                }
            }
        }
        return selectedOptions
    }
    
    func configurePage(){}
    
    func configureOptions(options : [NeonLongOnboardingOption]){}
    
    func optionDidSelect(_ option: NeonLongOnboardingPageOptionView) {
        
    }
    func optionDidDeselect(_ option: NeonLongOnboardingPageOptionView) {
        
    }
    
    
}
