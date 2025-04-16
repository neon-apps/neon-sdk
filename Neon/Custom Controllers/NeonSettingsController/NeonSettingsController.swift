//
//  NeonSettingsController.swift
//  AI Note Taker
//
//  Created by Tuna Öztürk on 25.08.2024.
//

import UIKit
import NeonSDK

open class NeonSettingsController: UIViewController {
    
    public let scrollView = UIScrollView()
    public let stackView = UIStackView()
    public let titleLabel = UILabel()
    public let backButton = NeonSymbolButton()
    
    private var addedSections: [NeonSettingsSection] = []

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupScrollViewAndStackView()
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .white
        
        titleLabel.text = "Settings"
        titleLabel.font = Font.custom(size: 24, fontWeight: .SemiBold)
        titleLabel.textColor = NeonSettingsControllerConstants.primaryTextColor
        
        backButton.configure(with: NeonSymbols.chevron_left)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }

        let navBar = UIStackView(arrangedSubviews: [backButton, titleLabel, UIView()])
        navBar.axis = .horizontal
        navBar.alignment = .center
        navBar.spacing = 8
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func setupScrollViewAndStackView() {
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.left.right.bottom.equalToSuperview()
        }
        
        stackView.axis = .vertical
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.width.equalTo(view.snp.width).offset(-40)
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    public func configure(
        buttonTextColor: UIColor = .black,
        buttonBackgroundColor: UIColor = .white,
        buttonBorderColor: UIColor = .lightGray,
        buttonCornerRadius: CGFloat = 8.0,
        buttonHeight: CGFloat = 50.0,
        iconTintColor: UIColor? = nil,
        primaryTextColor: UIColor = .black,
        mainColor: UIColor = .blue,
        controller: UIViewController,
        pageTitleFont : UIFont = Font.custom(size: 24, fontWeight: .SemiBold),
        sectionTitleFont : UIFont = Font.custom(size: 18, fontWeight: .Bold),
        buttonTitleFont : UIFont = Font.custom(size: 16, fontWeight: .Medium)
    ) {
        NeonSettingsControllerConstants.buttonTextColor = buttonTextColor
        NeonSettingsControllerConstants.buttonBackgroundColor = buttonBackgroundColor
        NeonSettingsControllerConstants.buttonBorderColor = buttonBorderColor
        NeonSettingsControllerConstants.buttonCornerRadius = buttonCornerRadius
        NeonSettingsControllerConstants.buttonHeight = buttonHeight
        NeonSettingsControllerConstants.iconTintColor = iconTintColor
        NeonSettingsControllerConstants.primaryTextColor = primaryTextColor
        NeonSettingsControllerConstants.mainColor = mainColor
        NeonSettingsControllerConstants.controller = controller
        NeonSettingsControllerConstants.pageTitleFont = pageTitleFont
        NeonSettingsControllerConstants.sectionTitleFont = sectionTitleFont
        NeonSettingsControllerConstants.buttonTitleFont = buttonTitleFont
        
        update()
    }

    public func update() {
        titleLabel.textColor = NeonSettingsControllerConstants.primaryTextColor
        titleLabel.font = NeonSettingsControllerConstants.pageTitleFont
        backButton.tintColor = NeonSettingsControllerConstants.primaryTextColor
        view.backgroundColor = .white

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for section in addedSections {
            guard let controller = NeonSettingsControllerConstants.controller else { continue }
            guard let sectionView = section.view(
                buttonTextColor: NeonSettingsControllerConstants.buttonTextColor,
                buttonBackgroundColor: NeonSettingsControllerConstants.buttonBackgroundColor,
                buttonBorderColor: NeonSettingsControllerConstants.buttonBorderColor,
                buttonCornerRadius: NeonSettingsControllerConstants.buttonCornerRadius,
                buttonHeight: NeonSettingsControllerConstants.buttonHeight,
                iconTintColor: NeonSettingsControllerConstants.iconTintColor,
                primaryTextColor: NeonSettingsControllerConstants.primaryTextColor,
                mainColor: NeonSettingsControllerConstants.mainColor,
                controller: controller
            ) else { continue }

            stackView.addArrangedSubview(sectionView)
        }
    }

    public func addSection(_ section: NeonSettingsSection) {
        guard let controller = NeonSettingsControllerConstants.controller else { return }

        switch section {
        case .premiumButton(_, _, _, _, _, _, _), .restorePurchaseButton(_, _, _):
            if Neon.isUserPremium { return }
        default:
            break
        }

        addedSections.append(section)

        guard let sectionView = section.view(
            buttonTextColor: NeonSettingsControllerConstants.buttonTextColor,
            buttonBackgroundColor: NeonSettingsControllerConstants.buttonBackgroundColor,
            buttonBorderColor: NeonSettingsControllerConstants.buttonBorderColor,
            buttonCornerRadius: NeonSettingsControllerConstants.buttonCornerRadius,
            buttonHeight: NeonSettingsControllerConstants.buttonHeight,
            iconTintColor: NeonSettingsControllerConstants.iconTintColor,
            primaryTextColor: NeonSettingsControllerConstants.primaryTextColor,
            mainColor: NeonSettingsControllerConstants.mainColor,
            controller: controller
        ) else { return }

        stackView.addArrangedSubview(sectionView)
    }
}
