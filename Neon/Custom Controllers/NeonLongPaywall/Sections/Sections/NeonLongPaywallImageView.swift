//
//  NeonLongPaywallImageView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallImageView : BaseNeonLongPaywallSectionView{
    
    let imageView = UIImageView()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()
        setConstraint()
        
        switch type {
        case .image(let height, let image, let cornerRadious, let horizontalPadding, let contentMode):
            imageView.image = image
            imageView.contentMode = contentMode
            imageView.layer.cornerRadius = cornerRadious
            
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(height)
                make.left.right.equalToSuperview().inset(horizontalPadding)
            }
            
        case .imageWithURL(let height, let url, let cornerRadious, let horizontalPadding, let contentMode):
            imageView.setImage(urlString: url)
            imageView.contentMode = contentMode
            imageView.layer.cornerRadius = cornerRadious
            
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(height)
                make.left.right.equalToSuperview().inset(horizontalPadding)
            }
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
    }
    
    func configureView(){
        imageView.layer.masksToBounds = true
        addSubview(imageView)
      
    
    }
    
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
        }
    }
    
}
