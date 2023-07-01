//
//  File.swift
//  neonApps-chatgpt
//
//  Created by Tuna Öztürk on 25.06.2023.
//
#if !os(xrOS)
import Foundation
import SnapKit
import UIKit

@available(iOS 13.0, *)
public class NeonAdaptyPaywallButton: UIButton {
    
    static var arrPaywallButtons = [NeonAdaptyPaywallButton]()
    public override var isSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    
    var title: String = "" {
        didSet {
            updateTitleLabel()
        }
    }
    
    var subtitle: String = "" {
        didSet {
            updateTitleLabel()
        }
    }
    
    var isBestSeller: Bool = false {
        didSet {
            addBestSellerLabel()
        }
    }
    
    private let circleSize: CGFloat = 23.0
    let circleView = UIView()
    let bestSellerLabel = NeonPaddingLabel()
    var clickCompletion : (()->())? = nil
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(clicked), for: .touchUpInside)
        setupUI()
        NeonAdaptyPaywallButton.arrPaywallButtons.append(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentHorizontalAlignment = .left
        configureTitleLabel()
        configureButtonAppearance()
        addCircleView()
    }
    
    private func configureTitleLabel() {
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 2
        
        updateTitleLabel()
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: circleSize + 5)
    }
    
    private func updateTitleLabel() {
        let mainTitleFont = Font.custom(size: 15, fontWeight: .Medium)
        let mainTitleColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? UIColor.white : UIColor.black
        let mainTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: mainTitleFont,
            .foregroundColor: mainTitleColor
        ]
        let mainTitleString = "\(title)\n"
        let mainTitle = NSAttributedString(string: mainTitleString, attributes: mainTitleAttributes)
        
        let subtitleFont = Font.custom(size: 12, fontWeight: .Regular)
        let subtitleColor = UIColor.darkGray // Replace with the desired color
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: subtitleColor
        ]
        let subtitle = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        let combinedText = NSMutableAttributedString()
        combinedText.append(mainTitle)
        combinedText.append(subtitle)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        combinedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, combinedText.length))
        
        setAttributedTitle(combinedText, for: .normal)
    }
    
    private func configureButtonAppearance() {
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = AdaptyPaywallBuilder.shared.isDarkModeEnabled ? AdaptyPaywallBuilder.shared.darkColor : AdaptyPaywallBuilder.shared.lightColor
    }
    
    private func updateButtonAppearance() {
        if isSelected {
            layer.borderColor = AdaptyPaywallBuilder.shared.mainColor.cgColor
            circleView.isHidden = false
        } else {
            layer.borderColor = UIColor.clear.cgColor
            circleView.isHidden = true
            removeCircleView()
        }
    }
    
    private func addCircleView() {
        circleView.layer.borderColor = AdaptyPaywallBuilder.shared.mainColor.cgColor
        circleView.layer.borderWidth = 1
        circleView.layer.cornerRadius = circleSize / 2
        circleView.isHidden = true
        circleView.tag = 123 // Using a tag to identify the circle view later if needed
        addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(circleSize)
        }
        
        let dotSize = circleSize - 8
        let dotView = UIView()
        dotView.backgroundColor = AdaptyPaywallBuilder.shared.mainColor
        dotView.layer.cornerRadius = dotSize / 2
        circleView.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(dotSize)
        }
    }
    
    private func removeCircleView() {
        circleView.isHidden = true
    }
    
    private func addBestSellerLabel() {
        bestSellerLabel.text = AdaptyPaywallBuilder().bestSellerLabelText
        bestSellerLabel.topInset = 4
        bestSellerLabel.bottomInset = 4
        bestSellerLabel.leftInset = 10
        bestSellerLabel.rightInset = 10
        bestSellerLabel.font = Font.custom(size: 12, fontWeight: .SemiBold)
        bestSellerLabel.textColor = .white
        bestSellerLabel.textAlignment = .center
        bestSellerLabel.backgroundColor = AdaptyPaywallBuilder.shared.mainColor
        bestSellerLabel.layer.cornerRadius = 4.0
        bestSellerLabel.clipsToBounds = true
        guard let superview = self.superview else {
            fatalError("You should add the NeonAdaptyPaywallButton as subview before setting isBestSeller property.")
        }
        superview.addSubview(bestSellerLabel)
        bestSellerLabel.sizeToFit()
        bestSellerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top)
            make.right.equalTo(circleView.snp.left).offset(-15)
        }
        bestSellerLabel.layer.zPosition = 10
    }
    
    @objc public func clicked() {
        for button in NeonAdaptyPaywallButton.arrPaywallButtons {
            button.isSelected = false
            button.layer.borderColor = UIColor.clear.cgColor
            button.circleView.isHidden = true
        }
        isSelected.toggle()
        updateButtonAppearance()
        if let clickCompletion{
            clickCompletion()
        }
    }
    
}
#endif
