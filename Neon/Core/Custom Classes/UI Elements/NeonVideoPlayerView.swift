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
    public var shouldPlayForever : Bool = false{
        didSet{
            if shouldPlayForever{
                playForever()
            }
        }
    }
    
    private var observer = NSObject()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePlayer()
        configurePlayerViewController()
        player.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurePlayer()
        configurePlayerViewController()
    }
    

    public func configure(with videoFileName: String, fileExtension : String) {
        
        
        if let videoURL = Bundle.main.url(forResource: videoFileName, withExtension: fileExtension) {
            // Handle invalid URL
            player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        }
        
        if let videoURL = Bundle.module.url(forResource: videoFileName, withExtension: fileExtension) {
            // Handle invalid URL
            player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        }
    
    }
    
    
    public func deinitPlayer(){
        NotificationCenter.default.removeObserver(observer, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player?.pause()
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
    
    
    private func playForever(){
        observer = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main, using: { [self] notification in
            playerDidFinishPlaying()
        }) as! NSObject
    }
    
    @objc private func playerDidFinishPlaying() {
        player.seek(to: CMTime.zero)
        player.play()
     }
    
}
