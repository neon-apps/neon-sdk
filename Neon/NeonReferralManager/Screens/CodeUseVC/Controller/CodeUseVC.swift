//
//  CodeUseVC.swift
//  PromotionCode
//
//  Created by cihangirincaz on 30.07.2024.
//

import UIKit
import NeonSDK
import FirebaseFirestore
import FirebaseAuth

@available(iOS 16.0, *)
class CodeUseVC: UIViewController {
    //MARK: Properties
    var codeUseTextField = TextField(placeholder: "Enter code")
    var newCode = String()
    //MARK: Lifecycle
    init() {
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.gradientConfigure()
        NeonReferralDatabase.shared.fetchUsers { success in
            if success {
                self.arrayConverter()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NeonReferralConstants.shared.AllUser = []
        NeonReferralConstants.shared.newAllUsers = []
    }
    //MARK: Helpers
    func setupUI() {
        view.backgroundColor = NeonReferralConstants.backgroundColor
        let pageTitle = UILabel()
        let backButton = UIButton()
        let codeCheckButton = UIButton()
        let pasteButton = UIButton()

        codeCheckButton.backgroundColor = NeonReferralConstants.mainColor
        codeCheckButton.setTitle("Check", for: .normal)
        codeCheckButton.setTitleColor(NeonReferralConstants.buttonTextColor , for: .normal)
        codeCheckButton.layer.cornerRadius = 15
        codeCheckButton.addTarget(self, action: #selector(codeCheckButtonClicked), for: .touchUpInside)
        view.addSubview(codeCheckButton)
        codeCheckButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        codeUseTextField.backgroundColor = NeonReferralConstants.containerColor
        codeUseTextField.layer.cornerRadius = 12
        codeUseTextField.textColor = NeonReferralConstants.primaryTextColor
        view.addSubview(codeUseTextField)
        codeUseTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(56)
            make.bottom.equalTo(codeCheckButton.snp.top).offset(-24)
        }
        pasteButton.backgroundColor = NeonReferralConstants.mainColor
        pasteButton.setTitle("Paste", for: .normal)
        pasteButton.setTitleColor(NeonReferralConstants.buttonTextColor, for: .normal)
        pasteButton.layer.masksToBounds = true
        pasteButton.layer.cornerRadius = 4
        pasteButton.addTarget(self, action: #selector(pasteButtonClicked), for: .touchUpInside)
        view.addSubview(pasteButton)
        pasteButton.snp.makeConstraints { make in
            make.centerY.equalTo(codeUseTextField)
            make.right.equalTo(codeUseTextField.snp.right).inset(12)
            make.width.equalTo(77)
            make.height.equalTo(32)
        }
        pageTitle.text = "Enter Your Invite Code"
        pageTitle.font = Font.custom(size: 16, fontWeight: .Regular)
        pageTitle.textAlignment = .left
        pageTitle.textColor = NeonReferralConstants.primaryTextColor
        view.addSubview(pageTitle)
        pageTitle.snp.makeConstraints { make in
            make.bottom.equalTo(codeUseTextField.snp.top).offset(-24)
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        backButton.setImage(UIImage(named: "referral_crossButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageTitle.snp.centerY)
            make.right.equalTo(codeUseTextField.snp.right)
            make.width.height.equalTo(40)
        }
    }

    func gradientConfigure(){
        var gradientTopColor = UIColor()
        gradientTopColor = NeonReferralConstants.mainColor.withAlphaComponent(0.1)
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
    
    func arrayConverter(){
        for userID in NeonReferralConstants.shared.AllUser {
            let newUserID = String(userID.prefix(6))
            NeonReferralConstants.shared.newAllUsers.append(newUserID)
        }
    }
    func findFriendID(promotionCode: String) -> String {
        var friendID = String()

        for user in NeonReferralConstants.shared.AllUser {
            let prefix = String(user.prefix(6))
            if prefix == promotionCode {
                friendID.append(contentsOf: user)
            }
        }
        return friendID
    }
    func addOffer(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let promotionCode = self.codeUseTextField.text ?? "n/A"
        NeonReferralDatabase.shared.addCredit(for: userID, amount: NeonReferralConstants.prizeAmount)
        NeonReferralConstants.remainingCredit += NeonReferralConstants.prizeAmount
        print(NeonReferralConstants.remainingCredit)
        let friendID = self.findFriendID(promotionCode: promotionCode)
        NeonReferralDatabase.shared.setDatabase(userID: friendID) { result in
            switch result {
            case "haveCreditField":
                NeonReferralDatabase.shared.addCredit(for: friendID, amount: NeonReferralConstants.prizeAmount)
            case "createdCreditField":
                NeonReferralDatabase.shared.addCredit(for: friendID, amount: NeonReferralConstants.prizeAmount)
            case "error":
                print("There was an error creating the Credit field.")
            case "documentNotFound":
                print("The document for the user was not found.")
            default:
                print("Unexpected result: \(result)")
            }
        }
    }
    //MARK: Actions
    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }
    @objc func pasteButtonClicked(){
        if let clipboardString = UIPasteboard.general.string {
                   newCode = clipboardString
                   codeUseTextField.text = newCode
               } else {
                   print("No string found in clipboard.")
               }
    }
    
    @objc func codeCheckButtonClicked() {
        let enteredCode = self.codeUseTextField.text ?? "n/A"
        
        NeonReferralDatabase.shared.scanAllUsers(promotionCode: enteredCode) { result in
            switch result {
            case "badCode":
                NeonAlertManager.default.present(
                    title: "Invalid Code",
                    message: "The promo code you entered does not exist. Please check and try again.",
                    style: .actionSheet,
                    viewController: self,
                    overrideUserInterfaceStyle: NeonReferralConstants.overrideUserInterfaceStyle
                )
            case "yourCode":
                NeonAlertManager.default.present(
                    title: "Invalid Entry",
                    message: "You cannot use your own promo code. Please enter a different code.",
                    style: .actionSheet,
                    viewController: self,
                    overrideUserInterfaceStyle: NeonReferralConstants.overrideUserInterfaceStyle
                )
            case "promoCodeAdded":
                self.addOffer()
                NeonAlertManager.default.present(
                    title: "Success!",
                    message: "Congratulations! You and your friend have both earned \(String(NeonReferralConstants.prizeAmount)) credits.",
                    style: .actionSheet,
                    viewController: self,
                    overrideUserInterfaceStyle: NeonReferralConstants.overrideUserInterfaceStyle
                )
            case "noPromoCodeAdded":
                NeonAlertManager.default.present(
                    title: "Promo Code Already Used",
                    message: "You have already used this promo code. Each promo code can only be used once.",
                    style: .actionSheet,
                    viewController: self,
                    overrideUserInterfaceStyle: NeonReferralConstants.overrideUserInterfaceStyle
                )
            default:
                print("Unexpected result: \(result)")
            }
        }
    }

}


