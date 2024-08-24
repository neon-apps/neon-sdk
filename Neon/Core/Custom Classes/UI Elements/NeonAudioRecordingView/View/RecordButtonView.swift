//
//  RecordBottomView.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import NeonSDK
import Foundation
import UIKit
import SnapKit

class RecordButtonView: UIView {
    
    let voiceButton = UIButton()
    let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {

        infoLabel.text = "Tap to start recording"
        infoLabel.textColor = NeonAudioRecordingViewConstants.secondaryTextColor
        infoLabel.font = Font.custom(size: 10, fontWeight: .Regular)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.left.right.equalToSuperview().inset(40)
        }

       
        voiceButton.setImage(UIImage(named: "microphone"), for: .normal)
        voiceButton.tintColor = NeonAudioRecordingViewConstants.buttonTextColor
        voiceButton.backgroundColor = NeonAudioRecordingViewConstants.mainColor
        voiceButton.layer.cornerRadius = 8
        addSubview(voiceButton)
        voiceButton.snp.makeConstraints { make in
            make.bottom.equalTo(infoLabel.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(56)
        }

    }
}
