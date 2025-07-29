//
//  PlayButtonView.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import Foundation
import NeonSDK
import Foundation
import UIKit
import SnapKit

class PlayButtonView: UIView {
    
    let playButton = UIButton()
    let trashButton = UIButton()
    let replayButton = UIButton()
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
        
        infoLabel.text = "You can listen to your recorded audio,or delete."
        infoLabel.textColor = NeonAudioRecordingViewConstants.secondaryTextColor
        infoLabel.font = Font.custom(size: NeonAudioRecordingViewConstants.fontSize, fontWeight: .Regular)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.left.right.equalToSuperview().inset(40)
        }

       
        playButton.setImage(NeonSymbols.play_fill, for: .normal)
        playButton.imageView?.tintColor = NeonAudioRecordingViewConstants.buttonTextColor
        playButton.backgroundColor = NeonAudioRecordingViewConstants.mainColor
        playButton.layer.cornerRadius = 8
        addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(infoLabel.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        trashButton.setImage(NeonSymbols.trash, for: .normal)
        trashButton.imageView?.tintColor = NeonAudioRecordingViewConstants.mainColor
        addSubview(trashButton)
        trashButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.right.equalTo(playButton.snp.left).offset(-25)
            make.width.height.equalTo(56)
        }
        replayButton.isHidden = true
        replayButton.setImage(NeonSymbols.gobackward, for: .normal)
        replayButton.imageView?.tintColor = NeonAudioRecordingViewConstants.mainColor
        addSubview(replayButton)
        replayButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.left.equalTo(playButton.snp.right).offset(25)
            make.width.height.equalTo(56)
        }

    }
    
    func update() {
        let image = PlayerManager.shared.audioPlayer?.isPlaying == true ? NeonSymbols.pause_fill : NeonSymbols.play_fill
        playButton.setImage(image, for: .normal)
    }
    
    
}
