//
//  ProgressBarView.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import Foundation
import NeonSDK
import UIKit

class ProgressBarView: UIView {
    
    let progressBar = ProgressBar()
    let timerLabel = UILabel()

    private var timer: Timer?
    var seconds: Int = 0
    private let maxSeconds: Int = NeonAudioRecordingViewConstants.maximumRecordingDurationInSeconds
    var timerCompletion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 8
        backgroundColor = NeonAudioRecordingViewConstants.secondaryTextColor
        
        setupCircularProgressBar()

        timerLabel.textColor = NeonAudioRecordingViewConstants.primaryTextColor
        timerLabel.text = "00:00"
        timerLabel.font = Font.custom(size: 20, fontWeight: .Bold)
        timerLabel.textAlignment = .center
        addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupCircularProgressBar() {
        progressBar.trackColor = NeonAudioRecordingViewConstants.progressBarTrackColor
        progressBar.lineHeight = 12
        progressBar.progress = 0
        self.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(220)
        }
    }
    
    func startTimer(completion: @escaping () -> Void) {
        timerCompletion = completion
        seconds = 0
        timerLabel.text = formatTime(seconds)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        seconds = 0
        progressBar.progress = 0
        timerLabel.text = formatTime(seconds)
    }
    
    @objc private func updateTimer() {
        seconds += 1
        timerLabel.text = formatTime(seconds)
        progressBar.progress = Double(seconds) / Double(maxSeconds)
 
        if seconds >= maxSeconds {
            stopTimer()
            timerCompletion?()
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
