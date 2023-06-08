//
//  PaywallFeaturesView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 8.06.2023.
//


import Foundation
import UIKit




@available(iOS 13.0, *)
class NeonPaywallFeaturesTableView: NeonTableView<NeonPaywallFeature, NeonPaywallFeatureCell> {

    
    public var featureTextColor = UIColor.black
    public var featureIconBackgroundColor = UIColor.white
    public var featureIconTintColor = UIColor.white
    
    
     convenience init() {
        NeonPaywallFeature.arrFeatures = []
        self.init(
            objects: NeonPaywallFeature.arrFeatures,
            heightForRows: 44
        )
        
        updateUI()
    }
    
    private func updateUI(){
        backgroundColor = .clear
        contentInsetAdjustmentBehavior = .never
        isScrollEnabled = false
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! NeonPaywallFeatureCell
        cell.titleLabel.textColor = featureTextColor
        
        cell.imgIconBackground.backgroundColor = featureIconBackgroundColor
        cell.imgIcon.tintColor = featureIconTintColor
        cell.layer.cornerRadius = 12
        return cell
    }
    
    
}

