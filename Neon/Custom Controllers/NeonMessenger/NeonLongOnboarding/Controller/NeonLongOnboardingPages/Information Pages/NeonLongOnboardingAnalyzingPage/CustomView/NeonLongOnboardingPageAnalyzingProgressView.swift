//
//  NeonLongOnboardingPageAnalyzingPageProgressView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 14.11.2023.
//

import Foundation
import UIKit
import NeonSDK
import SnapKit

@available(iOS 13.0, *)
class NeonLongOnboardingPageAnalyzingProgressView: UIView {
    
    private let titleLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private var completionDuration: TimeInterval
    private var delay: TimeInterval
    var onProgressComplete: (() -> Void)
    // Property to set the titleLabel text
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    init(completionDuration: TimeInterval, delay: TimeInterval, onProgressComplete : @escaping (() -> Void) ) {
        self.completionDuration = completionDuration
        self.delay = delay
        self.onProgressComplete = onProgressComplete
        super.init(frame: .zero)
        setupViews()
        startProgress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(progressBar)
        progressBar.layer.cornerRadius = 4
        progressBar.layer.masksToBounds = true
        progressBar.trackTintColor = NeonLongOnboardingConstants.selectedOptionBackgroundColor
        progressBar.tintColor = NeonLongOnboardingConstants.selectedOptionBorderColor
        
        progressBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
        
        addSubview(titleLabel)
        titleLabel.textColor = NeonLongOnboardingConstants.textColor
        titleLabel.font = Font.custom(size: 16, fontWeight: .SemiBold)
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(progressBar.snp.top).offset(-10)
        }
        
        addSubview(progressLabel)
        progressLabel.textColor = NeonLongOnboardingConstants.textColor
        progressLabel.font = Font.custom(size: 14, fontWeight: .Regular)
        progressLabel.textAlignment = .right
        progressLabel.text = "0%"
        progressLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        

    }
    
    private func startProgress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                let currentProgress = self.progressBar.progress
                let increment = 0.1 / Float(self.completionDuration)
                self.progressBar.setProgress(currentProgress + increment, animated: true)
                self.progressLabel.text = "\(Int((currentProgress + increment) * 100))%"
                if self.progressBar.progress >= 1.0 {
                    timer.invalidate()
                    self.progressLabel.text = "100%"
                    onProgressComplete()
                }
            }
        }
    }
}

