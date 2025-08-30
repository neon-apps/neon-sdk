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

public final class RecordButtonView: UIView {
    enum State { case idle, recording }

    let voiceButton = UIButton()
    let infoLabel = UILabel()
    private let iconImageView = UIImageView()
    private let holdSquareView = UIView()
    private var squareW: Constraint?
    private var squareH: Constraint?
    private var squareAnimator: UIViewPropertyAnimator?
    private var pressStartTime: CFTimeInterval = 0
    private var displayLink: CADisplayLink?
    private(set) var state: State = .idle
    private var shouldUseHoldToFinish = false

    var onTap: (() -> Void)?
    var onHoldToFinishCompleted: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(buttonBackgroundColor: UIColor, buttonTextColor: UIColor, shouldUseHoldToFinish: Bool) {
        self.shouldUseHoldToFinish = shouldUseHoldToFinish
        voiceButton.backgroundColor = buttonBackgroundColor
        iconImageView.tintColor = buttonTextColor
        updateIcon()
        setupGestures()
    }

    func setState(_ newState: State, useHoldToFinish: Bool) {
        state = newState
        shouldUseHoldToFinish = useHoldToFinish
        updateIcon()
        resetSquare()
        updateInfoForState()
    }

    func showHoldHint() {
        infoLabel.text = "Hold 3s to finish"
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

        voiceButton.layer.cornerRadius = 8
        addSubview(voiceButton)
        voiceButton.snp.makeConstraints { make in
            make.bottom.equalTo(infoLabel.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(56)
        }

        iconImageView.contentMode = .scaleAspectFit
        voiceButton.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(28)
        }

        holdSquareView.backgroundColor = NeonAudioRecordingViewConstants.buttonTextColor
        holdSquareView.isHidden = true
        holdSquareView.layer.cornerRadius = 8
        holdSquareView.layer.masksToBounds = true
        voiceButton.addSubview(holdSquareView)
        holdSquareView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            squareW = make.width.equalTo(8).constraint
            squareH = make.height.equalTo(8).constraint
        }
    }

    private func setupGestures() {
        voiceButton.removeTarget(nil, action: nil, for: .allEvents)
        voiceButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        lp.minimumPressDuration = 0
        lp.cancelsTouchesInView = false
        voiceButton.addGestureRecognizer(lp)
    }

    private func updateIcon() {
        switch state {
        case .idle:
            iconImageView.image = NeonSymbols.mic_fill
        case .recording:
            iconImageView.image = NeonSymbols.stop_fill
        }
    }

    private func updateInfoForState() {
        switch state {
        case .idle:
            infoLabel.text = "Tap to start recording"
        case .recording:
            infoLabel.text = shouldUseHoldToFinish ? "Hold 3s to finish" : "Tap to finish recording"
        }
    }

    @objc private func tapped() {
        onTap?()
    }

    @objc private func handleLongPress(_ gr: UILongPressGestureRecognizer) {
        guard state == .recording, shouldUseHoldToFinish else { return }
        switch gr.state {
        case .began:
            startHoldAnimation()
        case .changed:
            break
        case .ended, .cancelled, .failed:
            endHold(gr.state == .ended)
        default:
            break
        }
    }

    private func startHoldAnimation() {
        layoutIfNeeded()
        holdSquareView.isHidden = false
        iconImageView.isHidden = true
        pressStartTime = CACurrentMediaTime()
        let targetSize = voiceButton.bounds.width
        squareAnimator?.stopAnimation(true)
        squareAnimator = UIViewPropertyAnimator(duration: 3.0, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.squareW?.update(offset: targetSize)
            self.squareH?.update(offset: targetSize)
            self.voiceButton.layoutIfNeeded()
        }
        squareAnimator?.addCompletion { [weak self] position in
            guard let self = self else { return }
            if position == .end {
                self.onHoldToFinishCompleted?()
            }
        }
        squareAnimator?.startAnimation()
        startDisplayLink()
    }

    private func endHold(_ endedNormally: Bool) {
        stopDisplayLink()
        if let animator = squareAnimator {
            if endedNormally {
                animator.stopAnimation(false)
                animator.finishAnimation(at: .current)
                let elapsed = CACurrentMediaTime() - pressStartTime
                if elapsed >= 3.0 {
                    onHoldToFinishCompleted?()
                } else {
                    resetSquare()
                }
            } else {
                animator.stopAnimation(true)
                resetSquare()
            }
        } else {
            resetSquare()
        }
    }

    private func resetSquare() {
        squareAnimator?.stopAnimation(true)
        squareAnimator = nil
        squareW?.update(offset: 8)
        squareH?.update(offset: 8)
        voiceButton.layoutIfNeeded()
        holdSquareView.isHidden = true
        iconImageView.isHidden = false
    }

    private func startDisplayLink() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick() {
        let elapsed = CACurrentMediaTime() - pressStartTime
        if elapsed >= 3.0 {
            stopDisplayLink()
        }
    }
}
