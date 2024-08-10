//
//  CodeViewVC.swift
//  PromotionCode
//
//  Created by cihangirincaz on 30.07.2024.
//

import UIKit
import NeonSDK

class CodeViewVC: UIViewController {
    //MARK: Properties
    var remainingCredit = UILabel()
    var showcaseImage = UIImageView()
    var freeX = UILabel()
    var descriptionLabel = UILabel()
    var newUserID = String()
    private var notificationLabel: UILabel!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        gradientConfigure()
        setupNotificationLabel()


    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = .systemBackground
        let backButton = UIButton()
        backButton.setImage(.back , for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(50)
        }
        remainingCredit.text = "Remaining Invite Credits: 0 "
        remainingCredit.font = Font.custom(size: 14, fontWeight: .Regular)
        remainingCredit.layer.masksToBounds = true
        remainingCredit.layer.cornerRadius = 8
        remainingCredit.backgroundColor = .remainingBackgroundColor
        remainingCredit.textAlignment = .center
        remainingCredit.textColor = .remainingTextColor
        view.addSubview(remainingCredit)
        remainingCredit.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(34)
            make.width.equalToSuperview().multipliedBy(0.481)
        }
        showcaseImage.image = .codeViewImg
        showcaseImage.contentMode = .scaleAspectFit
        showcaseImage.backgroundColor = .clear
        view.addSubview(showcaseImage)
        showcaseImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(98)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.frame.width*0.317)
        }
        let inviteFriendsLabel = UILabel()
        inviteFriendsLabel.text = "Invite Friends"
        inviteFriendsLabel.textColor = .remainingTextColor
        inviteFriendsLabel.backgroundColor = .clear
        inviteFriendsLabel.font = Font.custom(size: 32, fontWeight: .Medium)
        view.addSubview(inviteFriendsLabel)
        inviteFriendsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(showcaseImage.snp.bottom).offset(32)
            make.height.equalTo(47)
        }
        freeX.text = "Get Free Songs!"
        freeX.textColor = .customBlue
        freeX.backgroundColor = .clear
        freeX.font = Font.custom(size: 40, fontWeight: .Medium)
        view.addSubview(freeX)
        freeX.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inviteFriendsLabel.snp.bottom).offset(0)
            make.height.equalTo(47)
        }
        let firstLabel = UILabel()
        firstLabel.text = "1. Share your code with your friends"
        firstLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        firstLabel.textColor = .remainingTextColor
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(freeX.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(35)
            make.height.equalTo(24)
        }
        let firstImageView = UIImageView(image: .selfie)
        firstImageView.contentMode = .scaleAspectFit
        firstImageView.tintColor = .white
        view.addSubview(firstImageView)
        firstImageView.snp.makeConstraints { make in
            make.left.equalTo(firstLabel.snp.right).offset(4)
            make.centerY.equalTo(firstLabel.snp.centerY)
            make.height.equalTo(24)
        }
        let secondLabel = UILabel()
        secondLabel.text = "2. They enter your code in Settings"
        secondLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        secondLabel.textColor = .remainingTextColor
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(35)
            make.height.equalTo(24)
        }
        let secondImageView = UIImageView(image: .phone)
        secondImageView.contentMode = .scaleAspectFit
        secondImageView.tintColor = .white
        view.addSubview(secondImageView)
        secondImageView.snp.makeConstraints { make in
            make.left.equalTo(secondLabel.snp.right).offset(4)
            make.centerY.equalTo(secondLabel.snp.centerY)
            make.height.equalTo(24)
        }
        let thirdLabel = UILabel()
        thirdLabel.text = "2. They enter your code in Settings"
        thirdLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        thirdLabel.textColor = .remainingTextColor
        view.addSubview(thirdLabel)
        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(35)
            make.height.equalTo(24)
        }
        let thirdImageView = UIImageView(image: .group)
        thirdImageView.contentMode = .scaleAspectFit
        thirdImageView.tintColor = .white
        view.addSubview(thirdImageView)
        thirdImageView.snp.makeConstraints { make in
            make.left.equalTo(thirdLabel.snp.right).offset(4)
            make.centerY.equalTo(thirdLabel.snp.centerY)
            make.height.equalTo(24)
        }
        descriptionLabel.text = "Keep invitinig friends and earn free song credits for\neach one who joins💚"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Font.custom(size: 14, fontWeight: .Regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .placeholderGray
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        let userCodeLabel = UILabel()
        userCodeLabel.text = "User Code: "
        userCodeLabel.textColor = .remainingTextColor
        userCodeLabel.textAlignment = .left
        userCodeLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        view.addSubview(userCodeLabel)
        userCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
//        let ReferanceCodeLabel = UILabel()
//        guard let userID = AuthManager.currentUserID else { return }
//        newUserID = String(userID.prefix(6))
//        ReferanceCodeLabel.text = newUserID
//        ReferanceCodeLabel.textColor = .remainingTextColor
//        ReferanceCodeLabel.layer.borderWidth = 1
//        ReferanceCodeLabel.layer.masksToBounds = true
//        ReferanceCodeLabel.layer.cornerRadius = 12
//        ReferanceCodeLabel.layer.borderColor = UIColor.darkGray.cgColor
//        view.addSubview(ReferanceCodeLabel)
//        ReferanceCodeLabel.snp.makeConstraints { make in
//            make.top.equalTo(userCodeLabel.snp.bottom).offset(8)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(48)
//            make.width.equalToSuperview().multipliedBy(0.9)
//        }
        let copyButton = UIButton()
        copyButton.backgroundColor = .systemBlue
        copyButton.setTitle("Copy", for: .normal)
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.layer.masksToBounds = true
        copyButton.layer.cornerRadius = 4
        copyButton.addTarget(self, action: #selector(copyButtonClicked), for: .touchUpInside)
        view.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.centerY.equalTo(ReferanceCodeLabel)
            make.right.equalTo(ReferanceCodeLabel.snp.right).inset(10)
            make.width.equalTo(70)
        }
        let inviteButton = UIButton()
        inviteButton.backgroundColor = .systemBlue
        inviteButton.setTitle("Invite", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.layer.masksToBounds = true
        inviteButton.layer.cornerRadius = 16
        inviteButton.addTarget(self, action: #selector(inviteButtonClicked), for: .touchUpInside)
        view.addSubview(inviteButton)
        inviteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func gradientConfigure(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
          UIColor.gradientBlue.cgColor,
          UIColor.black.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func setupNotificationLabel() {
        notificationLabel = UILabel()
        notificationLabel.text = "Kopyalandı!"
        notificationLabel.textColor = .white
        notificationLabel.backgroundColor = .black
        notificationLabel.textAlignment = .center
        notificationLabel.isHidden = true
        
        view.addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    func showNotification() {
          notificationLabel.isHidden = false
          UIView.animate(withDuration: 0.3, animations: {
              self.notificationLabel.alpha = 1.0
          }) { _ in
              UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                  self.notificationLabel.alpha = 0.0
              }) { _ in
                  self.notificationLabel.isHidden = true
              }
          }
      }
    //MARK: Actions
    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }
    @objc func copyButtonClicked(){
        UIPasteboard.general.string = newUserID
        showNotification()
    }
    @objc func inviteButtonClicked(){
        print("invited")
    }
}

extension UIColor {
    static var remainingBackgroundColor: UIColor { .init(red: 0.141, green: 0.227, blue: 0.450, alpha: 1) }
    static var remainingTextColor: UIColor { .init(red: 0.823, green: 0.839, blue: 0.894, alpha: 1) }
    static var gradientBlack: UIColor { .init(red: 0.066, green: 0.019, blue: 0.031, alpha: 1) }
    static var gradientBlue: UIColor { .init(red: 0.117, green: 0.160, blue: 0.313, alpha: 1) }
    static var customBlue: UIColor { .init(red: 0.223, green: 0.466, blue: 0.937, alpha: 1) }
    static var placeholderGray: UIColor { .init(red: 0.400, green: 0.415, blue: 0.466, alpha: 1) }

}
