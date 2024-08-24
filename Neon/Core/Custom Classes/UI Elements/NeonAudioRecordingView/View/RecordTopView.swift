//
//  TopView.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import Foundation
import UIKit
import NeonSDK

class RecordTopView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "microphone")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = NeonAudioRecordingViewConstants.primaryTextColor
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }

        let titleLabel = UILabel()
        titleLabel.text = NeonAudioRecordingViewConstants.title
        titleLabel.textColor = NeonAudioRecordingViewConstants.primaryTextColor
        titleLabel.font = Font.custom(size: 16, fontWeight: .Bold)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        let subtitleLabel = UILabel()
        let subtitleText = NeonAudioRecordingViewConstants.description
        subtitleLabel.text = subtitleText
        subtitleLabel.textColor = NeonAudioRecordingViewConstants.secondaryTextColor
        subtitleLabel.font = Font.custom(size: 12, fontWeight: .Regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(40)
        }
    }
}
