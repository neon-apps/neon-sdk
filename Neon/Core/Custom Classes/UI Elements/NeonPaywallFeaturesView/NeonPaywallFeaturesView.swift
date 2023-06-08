//
//  NeonPaywallFeaturesView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 8.06.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class NeonPaywallFeaturesView: UIView {
    

    var paywallFeaturesTableView = NeonPaywallFeaturesTableView()
    
    
    public var featureTextColor = UIColor.black{
        didSet{
            paywallFeaturesTableView.featureTextColor = featureTextColor
        }
    }
    public var featureIconBackgroundColor = UIColor.black{
        didSet{
            paywallFeaturesTableView.featureIconBackgroundColor = featureIconBackgroundColor
        }
    }
    public var featureIconTintColor = UIColor.white{
        didSet{
            paywallFeaturesTableView.featureIconTintColor = featureIconTintColor
        }
    }

    
    public init() {
        super.init(frame: .zero)

        
      
        addSubview(paywallFeaturesTableView)
        paywallFeaturesTableView.backgroundColor = .clear
        paywallFeaturesTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(44 * NeonPaywallFeature.arrFeatures.count)
        }
     
   
    }
    
    public func addFeature(title : String, icon : UIImage){
        NeonPaywallFeature.arrFeatures.append(NeonPaywallFeature(title: title, icon: icon))
        paywallFeaturesTableView.objects = NeonPaywallFeature.arrFeatures
        paywallFeaturesTableView.snp.updateConstraints { make in
            make.height.equalTo(44 * NeonPaywallFeature.arrFeatures.count)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

