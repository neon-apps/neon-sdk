//
//  RecordYourVoiceView.swift
//  FaceDance
//
//  Created by Burak Çiçek on 2.08.2024.
//



import NeonSDK
import UIKit
import SnapKit

public class NeonAudioRecordingView: UIView {
    public var configureActions: ((_ action: NeonAudioRecordingAction) -> ())?
    public enum NeonAudioRecordingAction {
        case audioSavedLocally(_ audioId: String?)
        case recordingCompleted(_ url: String, _ recordingDurationInSeconds: Int)
        case recordingDeleted
    }

    var progressBarView: ProgressBarView?
    var processingView: RecordingProcessingView?
    var topView: RecordTopView?
    var recordButtonView: RecordButtonView?
    var playButtonView: PlayButtonView?
    var sliderView: SliderView?
    private var isRecording = false
    public var shouldAllowListenRecording = true

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func configure(controller: UIViewController,
                          mainColor: UIColor,
                          primaryTextColor: UIColor,
                          secondaryTextColor: UIColor,
                          buttonTextColor: UIColor,
                          progressBarTrackColor: UIColor,
                          progressBarTintColor: UIColor? = nil,
                          sliderTrackColor: UIColor,
                          loaderColor: UIColor? = nil,
                          buttonBackgroundColor: UIColor? = nil,
                          title: String,
                          description: String,
                          fontSize: CGFloat = 14,
                          recordButtonImage: UIImage = NeonSymbols.mic_fill,
                          maximumRecordingDurationInSeconds: Int,
                          shouldHoldToFinishRecording: Bool = false) {
        NeonAudioRecordingViewConstants.controller = controller
        NeonAudioRecordingViewConstants.mainColor = mainColor
        NeonAudioRecordingViewConstants.primaryTextColor = primaryTextColor
        NeonAudioRecordingViewConstants.secondaryTextColor = secondaryTextColor
        NeonAudioRecordingViewConstants.buttonTextColor = buttonTextColor
        NeonAudioRecordingViewConstants.buttonBackgroundColor = buttonBackgroundColor ?? mainColor
        NeonAudioRecordingViewConstants.progressBarTrackColor = progressBarTrackColor
        NeonAudioRecordingViewConstants.progressBarTintColor = progressBarTintColor ?? mainColor
        NeonAudioRecordingViewConstants.sliderTrackColor = sliderTrackColor
        NeonAudioRecordingViewConstants.title = title
        NeonAudioRecordingViewConstants.description = description
        NeonAudioRecordingViewConstants.fontSize = fontSize
        NeonAudioRecordingViewConstants.recordingButtonImage = recordButtonImage
        NeonAudioRecordingViewConstants.maximumRecordingDurationInSeconds = maximumRecordingDurationInSeconds
        NeonAudioRecordingViewConstants.loaderColor = loaderColor ?? mainColor
        NeonAudioRecordingViewConstants.shouldHoldToFinishRecording = shouldHoldToFinishRecording
        setupView()
        setupNotifications()
    }

    func setupView() {
        backgroundColor = .clear

        topView = RecordTopView()
        guard let topView = topView else { return }
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        recordButtonView = RecordButtonView()
        guard let recordButtonView = recordButtonView else { return }
        recordButtonView.infoLabel.font = Font.custom(size: NeonAudioRecordingViewConstants.fontSize, fontWeight: .Regular)
        recordButtonView.tintColor = NeonAudioRecordingViewConstants.buttonTextColor
        recordButtonView.configure(buttonBackgroundColor: NeonAudioRecordingViewConstants.buttonBackgroundColor,
                                   buttonTextColor: NeonAudioRecordingViewConstants.buttonTextColor,
                                   shouldUseHoldToFinish: NeonAudioRecordingViewConstants.shouldHoldToFinishRecording)
        recordButtonView.onTap = { [weak self] in
            guard let self = self else { return }
            if self.isRecording {
                if NeonAudioRecordingViewConstants.shouldHoldToFinishRecording == false {
                    self.stopRecording()
                } else {
                    self.recordButtonView?.showHoldHint()
                }
            } else {
                self.startRecording()
            }
        }
        recordButtonView.onHoldToFinishCompleted = { [weak self] in
            self?.stopRecording()
        }
        addSubview(recordButtonView)
        recordButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(recordButtonView.voiceButton.snp.top)
            make.left.right.equalToSuperview()
        }

        playButtonView = PlayButtonView()
        guard let playButtonView = playButtonView else { return }
        playButtonView.playButton.addTarget(self, action: #selector(handlePlayButtonClick), for: .touchUpInside)
        playButtonView.trashButton.addTarget(self, action: #selector(trashButtonClick), for: .touchUpInside)
        playButtonView.isHidden = true
        addSubview(playButtonView)
        playButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(recordButtonView.voiceButton.snp.top)
            make.left.right.equalToSuperview()
        }

        progressBarView = ProgressBarView()
        guard let progressBarView = progressBarView else { return }
        progressBarView.isHidden = true
        addSubview(progressBarView)
        progressBarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        processingView = RecordingProcessingView()
        guard let processingView = processingView else { return }
        processingView.isHidden = true
        addSubview(processingView)
        processingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        sliderView = SliderView()
        guard let sliderView = sliderView else { return }
        sliderView.isHidden = true
        addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }

    @objc private func handleVoiceButtonToggle() {
        if isRecording {
            if NeonAudioRecordingViewConstants.shouldHoldToFinishRecording {
                recordButtonView?.showHoldHint()
            } else {
                stopRecording()
            }
        } else {
            startRecording()
        }
    }

    open func startRecording() {
        RecordingManager.shared.requestRecordPermission { [weak self] granted, status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if granted {
                    self.isRecording = true
                    RecordingManager.shared.startRecording()
                    self.recordButtonView?.setState(.recording, useHoldToFinish: NeonAudioRecordingViewConstants.shouldHoldToFinishRecording)
                    if NeonAudioRecordingViewConstants.shouldHoldToFinishRecording {
                        self.recordButtonView?.infoLabel.text = "Hold to finish recording"
                    } else {
                        self.recordButtonView?.infoLabel.text = "Tap to finish recording"
                    }
                    self.progressBarView?.startTimer(completion: { [weak self] in
                        self?.stopRecording()
                    })
                    self.progressBarView?.isHidden = false
                }
                if status == .denied {
                    NeonAlertManager.default.present(
                        title: "Permission Needed",
                        message: "To record audio, please enable microphone access in your device settings.",
                        style: .alert,
                        buttons: [
                            AlertButton(title: "Settings", style: .default, completion: {
                                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                    if UIApplication.shared.canOpenURL(settingsUrl) {
                                        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                                    }
                                }
                            }),
                            AlertButton(title: "Cancel", style: .cancel, completion: {})
                        ],
                        viewController: NeonAudioRecordingViewConstants.controller
                    )
                }
            }
        }
    }

    private func stopRecording() {
        var recordingDurationInSeconds = progressBarView?.seconds ?? 0
        if recordingDurationInSeconds < 1 {
            resetRecordYourOwnVoiceView()
            return
        }
        RecordingManager.shared.requestRecordPermission { [weak self] granted, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if granted {
                    self.recordButtonView?.setState(.idle, useHoldToFinish: NeonAudioRecordingViewConstants.shouldHoldToFinishRecording)
                    self.recordButtonView?.infoLabel.text = "Tap to start recording"
                    self.progressBarView?.stopTimer()
                    self.progressBarView?.isHidden = true
                    self.processingView?.isHidden = false
                    self.recordButtonView?.isHidden = true
                    RecordingManager.shared.stopRecording(
                        localCompletion: { [weak self] audioId, _ in
                            guard let self = self else { return }
                            if let configureActions = self.configureActions {
                                configureActions(.audioSavedLocally(audioId))
                            }
                        },
                        remoteCompletion: { [weak self] remoteURL, error in
                            guard let self = self else { return }
                            self.isRecording = false
                            if let remoteURL, error == nil {
                                if self.shouldAllowListenRecording {
                                    self.playButtonView?.isHidden = false
                                    self.processingView?.isHidden = true
                                    self.sliderView?.isHidden = false
                                    PlayerManager.shared.remoteAudioUrl = remoteURL.absoluteString
                                    PlayerManager.shared.setupAudioPlayer()
                                    self.sliderView?.updateInitialLabels()
                                }
                                if let configureActions = self.configureActions {
                                    configureActions(.recordingCompleted(remoteURL.absoluteString, recordingDurationInSeconds))
                                }
                            } else {
                                self.recordButtonView?.isHidden = false
                                self.processingView?.isHidden = true
                            }
                        }
                    )
                }
            }
        }
    }

    public func stopPlayer() {
        PlayerManager.shared.playPause()
    }

    func resetRecordYourOwnVoiceView() {
        isRecording = false
        recordButtonView?.infoLabel.text = "Tap to start recording"
        recordButtonView?.setState(.idle, useHoldToFinish: NeonAudioRecordingViewConstants.shouldHoldToFinishRecording)
        progressBarView?.resetTimer()
        progressBarView?.isHidden = true
    }

    @objc func handlePlayButtonClick() {
        PlayerManager.shared.playPause()
        playButtonView?.update()
    }

    public func pausePlayer() {
        PlayerManager.shared.pause()
    }

    @objc func trashButtonClick() {
        NeonAlertManager.default.present(
            title: "Recording will be deleted",
            message: "Your recording will be deleted and cannot be recovered. This action can not be undone. Are you sure you want to delete it?",
            style: .alert,
            buttons: [
                AlertButton(title: "Delete", style: .destructive, completion: { [weak self] in
                    guard let self else { return }
                    PlayerManager.shared.pause()
                    sliderView?.isHidden = true
                    playButtonView?.isHidden = true
                    recordButtonView?.isHidden = false
                    progressBarView?.resetTimer()
                    PlayerManager.shared.localAudioFileName = nil
                    PlayerManager.shared.remoteAudioUrl = nil
                    playButtonView?.update()
                    if let configureActions = configureActions {
                        configureActions(.recordingDeleted)
                    }
                }),
                AlertButton(title: "Cancel", style: .cancel, completion: {})
            ],
            viewController: NeonAudioRecordingViewConstants.controller
        )
    }

    @objc func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: .audioPlayerDidFinishPlaying, object: nil)
    }

    @objc func audioPlayerDidFinishPlaying() {
        playButtonView?.update()
        sliderView?.updateInitialLabels()
    }
}
