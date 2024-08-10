//
//  CodeViewVC.swift
//  PromotionCode
//
//  Created by cihangirincaz on 30.07.2024.
//

import UIKit
import NeonSDK
import FirebaseFirestore

@available(iOS 16.0, *)
class CodeViewVC: UIViewController {
    //MARK: Properties
    var newUserID = String()
    let remainingCredit = NeonPaddingLabel()
    private var notificationView = UIView()
    let copyButton = UIButton()
    let userCodeLabel = UILabel()
    //MARK: Lifecycle
    init(){
           super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.gradientConfigure()
        self.setupNotificationView()
        NeonReferralDatabase.shared.fetchUserCredit() { credit, error in
               if let error = error {
                   print("Error fetching document: \(error)")
               } else if let credit = credit {
                   print("User credit : \(credit)")
                   NeonReferralConstants.remainingCredit = credit
                   self.fetchCredit()
               } else {
                   print("Document does not exist or `Credit` field is missing.")
               }
           }
    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = NeonReferralConstants.backgroundColor
        let backButton = UIButton()
    
        backButton.setImage( UIImage(named: "referral_crossButton", in: Bundle.module, compatibleWith: nil) , for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(40)
        }
        remainingCredit.text = "Remaining \(NeonReferralConstants.prizeTerminology.capitalized) Credits: 0 "
        remainingCredit.font = Font.custom(size: 14, fontWeight: .Regular)
        remainingCredit.layer.masksToBounds = true
        remainingCredit.layer.cornerRadius = 8
        remainingCredit.backgroundColor = NeonReferralConstants.containerColor
        remainingCredit.textAlignment = .center
        remainingCredit.textColor = NeonReferralConstants.primaryTextColor
        remainingCredit.leftInset = 8
        remainingCredit.rightInset = 8
        remainingCredit.topInset = 8
        remainingCredit.bottomInset = 8
        view.addSubview(remainingCredit)
        remainingCredit.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(34)
        }
        let showLottie = NeonAnimationView(animation: .custom(name: "gift_animation"), color: NeonReferralConstants.mainColor)
        view.addSubview(showLottie)
        showLottie.snp.makeConstraints { make in
            make.top.equalTo(remainingCredit.snp.bottom).offset(view.frame.height*0.043)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        let inviteFriendsLabel = UILabel()
        inviteFriendsLabel.text = "Invite Friends"
        inviteFriendsLabel.textColor = NeonReferralConstants.primaryTextColor
        inviteFriendsLabel.backgroundColor = .clear
        inviteFriendsLabel.font = Font.custom(size: 32, fontWeight: .Medium)
        view.addSubview(inviteFriendsLabel)
        inviteFriendsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(showLottie.snp.bottom).offset(view.frame.height*0.034)
            make.height.equalTo(47)
        }

        
        let freeAny = UILabel()
        freeAny.text = "Get Free \(NeonReferralConstants.prizeTerminology.capitalized)s!"
        freeAny.textColor = NeonReferralConstants.mainColor
        freeAny.backgroundColor = .clear
        freeAny.font = Font.custom(size: 40, fontWeight: .Medium)
        view.addSubview(freeAny)
        freeAny.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inviteFriendsLabel.snp.bottom).offset(0)
            make.height.equalTo(47)
        }
        let firstLabel = UILabel()
        firstLabel.text = "1. Share your code with your friends"
        firstLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        firstLabel.textColor = NeonReferralConstants.primaryTextColor
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(freeAny.snp.bottom).offset(view.frame.height*0.034)
            make.left.equalToSuperview().inset(35)
            make.height.equalTo(24)
        }
        let firstImageView = UIImageView(image: UIImage(named: "referral_selfieIcon", in: Bundle.module, compatibleWith: nil))
        firstImageView.contentMode = .scaleAspectFit
        firstImageView.tintColor = .white
        view.addSubview(firstImageView)
        firstImageView.snp.makeConstraints { make in
            make.left.equalTo(firstLabel.snp.right)
            make.centerY.equalTo(firstLabel.snp.centerY)
            make.height.equalTo(20)
        }
        let secondLabel = UILabel()
        secondLabel.text = "2. They enter your code in Settings"
        secondLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        secondLabel.textColor = NeonReferralConstants.primaryTextColor
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(view.frame.height*0.019)
            make.left.equalToSuperview().inset(35)
            make.height.equalTo(24)
        }
        let secondImageView = UIImageView(image: UIImage(named: "referral_PhoneIcon", in: Bundle.module, compatibleWith: nil))
        secondImageView.contentMode = .scaleAspectFit
        secondImageView.tintColor = .white
        view.addSubview(secondImageView)
        secondImageView.snp.makeConstraints { make in
            make.left.equalTo(secondLabel.snp.right).offset(4)
            make.centerY.equalTo(secondLabel.snp.centerY)
            make.height.equalTo(20)
        }
        let thirdLabel = UILabel()
        
        if NeonReferralConstants.prizeAmount > 1{
            thirdLabel.text = "3. You’ll receive \(NeonReferralConstants.prizeAmount) credits for free \(NeonReferralConstants.prizeTerminology.lowercased())s"
        }else{
            thirdLabel.text = "3. You’ll receive \(NeonReferralConstants.prizeAmount) credit for free \(NeonReferralConstants.prizeTerminology.lowercased())s"
        }
      
        thirdLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        thirdLabel.textColor = NeonReferralConstants.primaryTextColor
        view.addSubview(thirdLabel)
        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLabel.snp.bottom).offset(view.frame.height*0.019)
            make.left.equalToSuperview().inset(35)
            make.height.equalTo(24)
        }
        let thirdImageView = UIImageView(image: UIImage(named: "referral_groupIcon", in: Bundle.module, compatibleWith: nil))
        thirdImageView.contentMode = .scaleAspectFit
        thirdImageView.tintColor = .white
        view.addSubview(thirdImageView)
        thirdImageView.snp.makeConstraints { make in
            make.left.equalTo(thirdLabel.snp.right).offset(4)
            make.centerY.equalTo(thirdLabel.snp.centerY)
            make.height.equalTo(20)
        }
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Keep invitinig friends and earn free \(NeonReferralConstants.prizeTerminology.capitalized.lowercased()) credits for each one who joins!"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Font.custom(size: 14, fontWeight: .Regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = NeonReferralConstants.secondaryTextColor
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdLabel.snp.bottom).offset(view.frame.height*0.042)
            make.centerX.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
       
        let ReferanceCodeLabel = NeonPaddingLabel()
        let inviteButton = UIButton()
        inviteButton.backgroundColor = NeonReferralConstants.mainColor
        inviteButton.setTitle("Invite", for: .normal)
        inviteButton.setTitleColor(NeonReferralConstants.buttonTextColor, for: .normal)
        inviteButton.layer.masksToBounds = true
        inviteButton.layer.cornerRadius = 16
        inviteButton.addTarget(self, action: #selector(inviteButtonClicked), for: .touchUpInside)
        view.addSubview(inviteButton)
        inviteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(view.frame.height*0.07)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        guard let userID = AuthManager.currentUserID else { return }
        newUserID = String(userID.prefix(6))
        ReferanceCodeLabel.text = newUserID
        ReferanceCodeLabel.textColor = NeonReferralConstants.primaryTextColor
        ReferanceCodeLabel.backgroundColor = NeonReferralConstants.containerColor
        ReferanceCodeLabel.layer.borderWidth = 1
        ReferanceCodeLabel.layer.masksToBounds = true
        ReferanceCodeLabel.layer.cornerRadius = 12
        ReferanceCodeLabel.leftInset = 15
        view.addSubview(ReferanceCodeLabel)
        ReferanceCodeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inviteButton.snp.top).inset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        copyButton.backgroundColor = NeonReferralConstants.mainColor
        copyButton.setTitle("Copy", for: .normal)
        copyButton.setTitleColor(NeonReferralConstants.buttonTextColor, for: .normal)
        copyButton.layer.masksToBounds = true
        copyButton.layer.cornerRadius = 4
        copyButton.addTarget(self, action: #selector(copyButtonClicked), for: .touchUpInside)
        view.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.centerY.equalTo(ReferanceCodeLabel)
            make.right.equalTo(ReferanceCodeLabel.snp.right).inset(10)
            make.width.equalTo(70)
        }
        userCodeLabel.text = "User Code: "
        userCodeLabel.textColor = NeonReferralConstants.primaryTextColor
        userCodeLabel.textAlignment = .left
        userCodeLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        view.addSubview(userCodeLabel)
        userCodeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(ReferanceCodeLabel.snp.top).inset(-8)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func fetchCredit(){
        remainingCredit.text = "Remaining Invite Credits: \(NeonReferralConstants.remainingCredit) "
    }
    
    func gradientConfigure(){
        var gradientTopColor = UIColor()
        gradientTopColor = NeonReferralConstants.mainColor.withAlphaComponent(0.2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            gradientTopColor.cgColor,
            NeonReferralConstants.backgroundColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupNotificationView() {
        notificationView.backgroundColor = NeonReferralConstants.containerColor
        notificationView.layer.cornerRadius = 16
        notificationView.isHidden = true
        view.addSubview(notificationView)
        notificationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(userCodeLabel.snp.top).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(64)
        }
        let notificationViewText = UILabel()
        notificationViewText.text = "Copied to clipboard"
        notificationViewText.textColor = NeonReferralConstants.primaryTextColor
        notificationViewText.backgroundColor = .clear
        notificationViewText.font = Font.custom(size: 16, fontWeight: .Regular)
        notificationView.addSubview(notificationViewText)
        notificationViewText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(64)
        }
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "referral_copiedIcon", in: Bundle.module, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = NeonReferralConstants.mainColor
        notificationView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    func showNotification() {
          notificationView.isHidden = false
          UIView.animate(withDuration: 0.3, animations: {
              self.notificationView.alpha = 1.0
          }) { _ in
              UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                  self.notificationView.alpha = 0.0
              }) { _ in
                  self.notificationView.isHidden = true
                  self.copyButton.isEnabled = true
              }
          }
    }
    
    //MARK: Actions
    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }
    @objc func copyButtonClicked(){
        copyButton.isEnabled = false
        UIPasteboard.general.string = newUserID
        showNotification()
    }
    @objc func inviteButtonClicked(){
        let activityVC = UIActivityViewController(activityItems: [newUserID], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
