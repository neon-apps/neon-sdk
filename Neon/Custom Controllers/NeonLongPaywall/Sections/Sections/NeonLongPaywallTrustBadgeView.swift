//
//  NeonLongPaywallManagerTrustBadgeView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation

import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallTrustBadgeView : BaseNeonLongPaywallSectionView{
    
    
    let titleLabel = UILabel()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()

        switch type {
        case .trustBadge(let type):
            switch type {
            case .laurelWreath(let rating, let title, let year):
                titleLabel.text = title
                configureLaurelWreath(rating: rating, year: year)
            case .stars(let title):
                titleLabel.text = title
                configureStars()
            case .thropy(let title, let year):
                titleLabel.text = title
                configureThropy(year: year)
            }

            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
    }
    
    func configureView(){
        
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
       
        titleLabel.font = Font.custom(size: 20, fontWeight: .Bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = manager.constants.primaryTextColor
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        titleLabel.sizeToFit()
        
    }
    
    func configureLaurelWreath(rating : Double, year : Int){
        
        
        let lblRating = UILabel()
        addSubview(lblRating)
        lblRating.text = "\(rating)"
        lblRating.font = Font.custom(size: 36, fontWeight: .SemiBold)
        lblRating.textAlignment = .center
        lblRating.textColor = manager.constants.primaryTextColor
        lblRating.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        lblRating.sizeToFit()
        
        titleLabel.font = Font.custom(size: 16, fontWeight: .SemiBold)
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lblRating.snp.bottom).offset(-4)
        }
        
        let imgLaurelWreathLeft = UIImageView()
        imgLaurelWreathLeft.image = UIImage(named: "laurelWreathLeft", in: Bundle.module, compatibleWith: nil)
        imgLaurelWreathLeft.contentMode = .scaleAspectFit
        addSubview(imgLaurelWreathLeft)
        imgLaurelWreathLeft.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(titleLabel.snp.left).offset(-15)
        }
        
        let imgLaurelWreathRight = UIImageView()
        imgLaurelWreathRight.image = UIImage(named: "laurelWreathRight", in: Bundle.module, compatibleWith: nil)
        imgLaurelWreathRight.contentMode = .scaleAspectFit
        addSubview(imgLaurelWreathRight)
        imgLaurelWreathRight.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(15)
        }
        
        let lblYear = UILabel()
        addSubview(lblYear)
        lblYear.text = "\(year)"
        lblYear.font = Font.custom(size: 16, fontWeight: .Medium)
        lblYear.textAlignment = .center
        lblYear.textColor = manager.constants.primaryTextColor
        lblYear.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        lblYear.sizeToFit()
        
        snp.makeConstraints { make in
            make.bottom.equalTo(lblYear.snp.bottom)
        }
        
    }
    
    func configureStars(){
        let imgStars = UIImageView()
        imgStars.image = UIImage(named: "trust_badge_stars", in: Bundle.module, compatibleWith: nil)
        imgStars.contentMode = .scaleAspectFit
        addSubview(imgStars)
        imgStars.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        titleLabel.font = Font.custom(size: 30, fontWeight: .SemiBold)
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgStars.snp.bottom).offset(20)
        }
        
        snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
    
    func configureThropy(year : Int){
        
        let imgThropy = UIImageView()
        imgThropy.image = UIImage(named: "trust_badge_thropy", in: Bundle.module, compatibleWith: nil)
        imgThropy.contentMode = .scaleAspectFit
        addSubview(imgThropy)
        imgThropy.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(117)
        }
        
        titleLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgThropy.snp.bottom).offset(15)
        }
        
        let lblYear = UILabel()
        addSubview(lblYear)
        lblYear.text = "\(year)"
        lblYear.font = Font.custom(size: 14, fontWeight: .Medium)
        lblYear.textAlignment = .center
        lblYear.textColor = manager.constants.primaryTextColor
        lblYear.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        lblYear.sizeToFit()
        
        snp.makeConstraints { make in
            make.bottom.equalTo(lblYear.snp.bottom)
        }
    }
    
    
 
    
    
}


public enum NeonLongPaywallTrustBadgeType{
    case laurelWreath(rating : Double, title: String, year : Int)
    case stars(title : String)
    case thropy(title: String, year : Int)
}
