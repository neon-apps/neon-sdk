//
//  ConnectionsCell.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

#if !os(xrOS)
import Foundation
import UIKit
import NeonSDK

class ConnectionCell: NeonCollectionViewCell<NeonMessengerUser> {
    
    
    let imgPhoto = UIImageView()
    let lblName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configure(with user: NeonMessengerUser) {
        super.configure(with: user)
        imgPhoto.setImage(urlString: user.photoURL)
        lblName.text = user.firstName
    }
  
    private func setupSubviews() {
        
        
        contentView.addSubview(imgPhoto)
        imgPhoto.layer.masksToBounds = true
        imgPhoto.layer.cornerRadius = 25
        imgPhoto.contentMode = .scaleAspectFill
        imgPhoto.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
     
        contentView.addSubview(lblName)
        lblName.font = Font.custom(size: 13, fontWeight: .Regular)
        lblName.textAlignment = .center
        lblName.textColor = NeonMessengerConstants.secondaryTextColor
        lblName.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imgPhoto.snp.bottom).offset(10)
        }
    }
    
    
}
#endif
