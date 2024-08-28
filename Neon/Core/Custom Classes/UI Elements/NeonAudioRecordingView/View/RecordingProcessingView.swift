//
//  ProgressBarView.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import Foundation
import UIKit
import NeonSDK

class RecordingProcessingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let animationView = NeonAnimationView(animation: .loadingDots2, color: NeonAudioRecordingViewConstants.mainColor)
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Recording processing…"
        titleLabel.textColor = NeonAudioRecordingViewConstants.primaryTextColor
        titleLabel.font = Font.custom(size: 16, fontWeight: .Bold)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.centerY).offset(40)
            make.centerX.equalToSuperview()
        }

        let subtitleLabel = UILabel()
        let subtitleText = "Please wait..."
        subtitleLabel.text = subtitleText
        subtitleLabel.textColor = NeonAudioRecordingViewConstants.secondaryTextColor
        subtitleLabel.font = Font.custom(size: 12, fontWeight: .Regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
        }
    }
}
