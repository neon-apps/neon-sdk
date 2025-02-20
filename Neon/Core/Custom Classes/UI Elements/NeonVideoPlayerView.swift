//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 12.05.2024.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import SnapKit

public class NeonVideoPlayerView: UIView {
    
    public var playerViewController: AVPlayerViewController!
    public var player: AVPlayer!
    public var shouldPlayForever: Bool = false {
        didSet {
            if shouldPlayForever {
                playForever()
            }
        }
    }
    
    private var observer: NSObjectProtocol?
    private var lastPlayedURL: URL?
    private var isViewVisible = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePlayer()
        configurePlayerViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurePlayer()
        configurePlayerViewController()
    }

    public func configure(with videoFileName: String, fileExtension: String) {
        if let videoURL = Bundle.main.url(forResource: videoFileName, withExtension: fileExtension) ??
                           Bundle.module.url(forResource: videoFileName, withExtension: fileExtension) {
            lastPlayedURL = videoURL
            player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        }
    }

    public func configure(remoteFileUrl: String) {
        if let url = URL(string: remoteFileUrl) {
            lastPlayedURL = url
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }

    public func deinitPlayer() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            self.observer = nil
        }
        player?.pause()
        player.replaceCurrentItem(with: nil)
        player = nil
    }

    private func configurePlayer() {
        player = AVPlayer()
    }

    private func configurePlayerViewController() {
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.videoGravity = .resizeAspectFill
        playerViewController.showsPlaybackControls = false
        addSubview(playerViewController.view)
        playerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func playForever() {
        observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.playerDidFinishPlaying()
        }
    }

    @objc private func playerDidFinishPlaying() {
        player.seek(to: .zero)
        player.play()
    }

    // MARK: - Lifecycle Handling
    
    public func didAppear() {
        isViewVisible = true
        restorePlayer()
    }

    public func didDisappear() {
        isViewVisible = false
        deinitPlayer()
    }

    private func restorePlayer() {
        guard isViewVisible, player == nil, let lastPlayedURL = lastPlayedURL else { return }
        configurePlayer()
        configurePlayerViewController()
        player.replaceCurrentItem(with: AVPlayerItem(url: lastPlayedURL))
        player.play()
    }
}
