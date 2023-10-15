//
//  MessagesCell.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

#if !os(xrOS)
import Foundation
import UIKit
import NeonSDK

class ChatCell: NeonTableViewCell<NeonMessengerUser> {
    
    
    let imgPhoto = UIImageView()
    let lblName = UILabel()
    let lblMessage = UILabel()
    let lblLastMessageDate = UILabel()
    let dotNewMessage = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func configure(with user: NeonMessengerUser) {
        super.configure(with: user)
        imgPhoto.setImage(urlString: user.photoURL)
        lblName.text = user.fullName
        lblMessage.text = user.lastMessage?.content
        lblLastMessageDate.text = user.lastMessage?.date.returnMessageDate()
        if let lastMessage = user.lastMessage{
            dotNewMessage.isHidden = lastMessage.isRead
        }
        
    }
  
    private func setupSubviews() {
        
        backgroundColor = NeonMessengerConstants.primaryBackgroundColor
        
        contentView.addSubview(dotNewMessage)
        dotNewMessage.backgroundColor = UIColor(red: 0.98, green: 0.4, blue: 0.314, alpha: 1)
        dotNewMessage.layer.cornerRadius = 3
        dotNewMessage.layer.masksToBounds = true
        dotNewMessage.snp.makeConstraints { make in
            make.height.width.equalTo(6)
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(imgPhoto)
        imgPhoto.contentMode = .scaleAspectFill
        imgPhoto.layer.masksToBounds = true
        imgPhoto.layer.cornerRadius = 25
        imgPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.left.equalTo(dotNewMessage.snp.right ).offset(10)
            make.centerY.equalToSuperview()
        }
     
        contentView.addSubview(lblName)
        lblName.font = Font.custom(size: 16, fontWeight: .Bold)
        lblName.textAlignment = .center
        lblName.textColor = NeonMessengerConstants.primaryTextColor
        lblName.snp.makeConstraints { make in
            make.left.equalTo(imgPhoto.snp.right).offset(20)
            make.top.equalTo(imgPhoto.snp.top).offset(3)
        }
     
        
        contentView.addSubview(lblLastMessageDate)
        lblLastMessageDate.font = Font.custom(size: 12, fontWeight: .Regular)
        lblLastMessageDate.textAlignment = .right
        lblLastMessageDate.textColor = NeonMessengerConstants.secondaryTextColor
        lblLastMessageDate.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(25)
            make.centerY.equalTo(lblName.snp.centerY)
        }
        lblName.sizeToFit()
        
        
        contentView.addSubview(lblMessage)
        lblMessage.font = Font.custom(size: 12, fontWeight: .Regular)
        lblMessage.textAlignment = .center
        lblMessage.textColor = NeonMessengerConstants.secondaryTextColor
        lblMessage.snp.makeConstraints { make in
            make.left.equalTo(imgPhoto.snp.right).offset(20)
            make.right.equalTo(lblLastMessageDate.snp.left).offset(-40)
            make.bottom.equalTo(imgPhoto.snp.bottom).inset(3)
        }
    }
    
    
}
#endif
