//
//  SliderView.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import Foundation
import Foundation
import UIKit
import NeonSDK

class SliderView: UIView {
    
    let progressSlider = UISlider()
    let currentTimeLabel = UILabel()
    let remainingDurationLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupNotifications()
    }
    
    private func setupView() {
        progressSlider.minimumValue = 0
        progressSlider.maximumTrackTintColor = NeonAudioRecordingViewConstants.secondaryTextColor
        progressSlider.tintColor = NeonAudioRecordingViewConstants.mainColor
        progressSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        let thumbImage = createThumbImage(color: NeonAudioRecordingViewConstants.mainColor, size: CGSize(width: 20, height: 20))
               progressSlider.setThumbImage(thumbImage, for: .normal)
        addSubview(progressSlider)
        progressSlider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(45)
            make.centerX.equalToSuperview()
        }
        
        currentTimeLabel.text = "0:00"
        currentTimeLabel.font = Font.custom(size: 14, fontWeight: .Light)
        currentTimeLabel.textColor = NeonAudioRecordingViewConstants.primaryTextColor
        currentTimeLabel.textAlignment = .left
        addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(progressSlider)
            make.top.equalTo(progressSlider.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        remainingDurationLabel.text = "0:00"
        remainingDurationLabel.font = Font.custom(size: 14, fontWeight: .Light)
        remainingDurationLabel.textColor = NeonAudioRecordingViewConstants.primaryTextColor
        remainingDurationLabel.textAlignment = .right
        addSubview(remainingDurationLabel)
        remainingDurationLabel.snp.makeConstraints { make in
            make.right.equalTo(progressSlider)
            make.top.equalTo(progressSlider.snp.bottom).offset(10)
        }
        
    }
    
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        PlayerManager.shared.updateSliderValue(slider)
        updateLabels()
    }
    func updateInitialLabels() {
        guard let audioPlayer = PlayerManager.shared.audioPlayer else { return }
        
        progressSlider.maximumValue = Float(audioPlayer.duration)
        progressSlider.value = 0
        currentTimeLabel.text = formatTime(time: 0)
        remainingDurationLabel.text = formatTime(time: audioPlayer.duration)
    }
    func updateLabels() {
        guard let audioPlayer = PlayerManager.shared.audioPlayer else { return }
        
        let currentTime = audioPlayer.currentTime
        let remainingTime = audioPlayer.duration - currentTime
        
        currentTimeLabel.text = formatTime(time: currentTime)
        remainingDurationLabel.text = formatTime(time: remainingTime)
    }
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    private func createThumbImage(color: UIColor, size: CGSize) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            color.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(_:)), name: .updateProgress, object: nil)
    }
    @objc func updateProgress(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let currentTime = userInfo["currentTime"] as? TimeInterval,
              let duration = userInfo["duration"] as? TimeInterval else { return }
        
        progressSlider.maximumValue = Float(duration)
        progressSlider.value = Float(currentTime)
        currentTimeLabel.text = formatTime(time: currentTime)
        remainingDurationLabel.text = formatTime(time: duration - currentTime)
    }
}
