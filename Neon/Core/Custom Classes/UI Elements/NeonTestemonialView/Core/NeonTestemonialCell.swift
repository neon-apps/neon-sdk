//
//  NeonTestemonialCell.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation
import UIKit


class NeonTestemonialCell: NeonCollectionViewCell<NeonTestemonial> {
    
    public let titleLabel = UILabel()
    public let testemonialLabel = UILabel()
    public let imgStars = UIImageView()
    public let authorLabel = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configure(with testemonial: NeonTestemonial) {
        super.configure(with: testemonial)
        titleLabel.text = testemonial.title
        testemonialLabel.text = testemonial.testemonial
        authorLabel.text = testemonial.author
    }
  
    private func setupSubviews() {
        
        layer.masksToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let topSpacer = UIView() // Add top spacer view
        stackView.addArrangedSubview(topSpacer)
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
        stackView.addArrangedSubview(imgStars)
        imgStars.image = UIImage(named: "img_stars", in: Bundle.module, compatibleWith: nil)
        imgStars.contentMode = .scaleAspectFit
        
       
        imgStars.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        stackView.addArrangedSubview(testemonialLabel)
        testemonialLabel.font = Font.custom(size: 12, fontWeight: .Regular)
        testemonialLabel.numberOfLines = 3
        testemonialLabel.textAlignment = .center
        testemonialLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
      
        
        stackView.addArrangedSubview(authorLabel)
        authorLabel.font = Font.custom(size: 15, fontWeight: .Medium)
        authorLabel.textAlignment = .center
        authorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
        
        let bottomSpacer = UIView() // Add bottom spacer view
        stackView.addArrangedSubview(bottomSpacer)
   
       
        
        
    }
    
    
}
#endif
