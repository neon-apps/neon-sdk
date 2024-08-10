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
        view.backgroundColor = NeonReferralConstants.sheetBackgroundColor
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
        codeUseTextField.layer.borderWidth = 1
        codeUseTextField.layer.borderColor = NeonReferralConstants.textFieldBordorColor.cgColor
        codeUseTextField.backgroundColor = NeonReferralConstants.textFieldbackgroundcolor
        codeUseTextField.layer.cornerRadius = 12
        codeUseTextField.textColor = NeonReferralConstants.mainTextColor
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
        pageTitle.textColor = NeonReferralConstants.mainTextColor
        view.addSubview(pageTitle)
        pageTitle.snp.makeConstraints { make in
            make.bottom.equalTo(codeUseTextField.snp.top).offset(-24)
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        backButton.setImage(.back, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageTitle.snp.centerY)
            make.right.equalTo(codeUseTextField.snp.right)
            make.width.height.equalTo(40)
        }
    }

    func arrayConverter(){
        for userID in NeonReferralConstants.shared.AllUser {
            let newUserID = String(userID.prefix(6))
            NeonReferralConstants.shared.newAllUsers.append(newUserID)
        }
        print(NeonReferralConstants.shared.newAllUsers)
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
        NeonReferralDatabase.shared.addCredit(for: userID, amount: NeonReferralConstants.amount)
        NeonReferralConstants.remainingCredit += NeonReferralConstants.amount
        print(NeonReferralConstants.remainingCredit)
        let friendID = self.findFriendID(promotionCode: promotionCode)
        NeonReferralDatabase.shared.setDatabase(userID: friendID) { result in
            switch result {
            case "haveCreditField":
                NeonReferralDatabase.shared.addCredit(for: friendID, amount: NeonReferralConstants.amount)
            case "createdCreditField":
                NeonReferralDatabase.shared.addCredit(for: friendID, amount: NeonReferralConstants.amount)
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
    
    @objc func codeCheckButtonClicked(){
        let promotionCode = self.codeUseTextField.text ?? "n/A"
        NeonReferralDatabase.shared.scanAllUsers(promotionCode: promotionCode) { result in
            switch result {
            case "badCode":
                NeonAlertManager.default.present(title: "Error!", message: "There is no such promo code", style: .actionSheet, viewController: self)
            case "yourCode":
                NeonAlertManager.default.present(title: "Error!", message: "This code is your code. Please enter another code.", style: .actionSheet, viewController: self)
            case "promoCodeAdded":
                self.addOffer()
                NeonAlertManager.default.present(title: "Succesful", message: "Congratulations! You and your friend earned \(String(NeonReferralConstants.amount)) credits.", style: .actionSheet, viewController: self)
            case "noPromoCodeAdded":
                NeonAlertManager.default.present(title: "Error!", message: "You can only use a promo code once.", style: .actionSheet, viewController: self)
            default:
                print("Unknown result: \(result)")
            }
        }
    }
}


