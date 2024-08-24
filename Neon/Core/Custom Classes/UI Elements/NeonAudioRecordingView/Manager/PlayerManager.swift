//
//  PlayerManager.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//


import Foundation
import UIKit
import AVKit
import NeonSDK
class PlayerManager: NSObject {
    static let shared = PlayerManager()
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    var remoteAudioUrl: String? = nil 
    var localAudioFileName: String? = nil
    
    func setupAudioPlayer() {
        guard let localAudioFileName, !localAudioFileName.isEmpty else {
            print("Local audio file name is empty")
            return
        }
        
        let filePath = getDocumentsDirectory().appendingPathComponent("Recordings").appendingPathComponent("\(localAudioFileName).m4a").path
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("Audio file not found at path: \(filePath)")
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to initialize audio player: \(error)")
        }
    }
    
    func playPause() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        
        guard let audioPlayer = audioPlayer else { return }
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
            startTimer()
        }
        updateProgress()
    }
    
    func forward() {
        guard let audioPlayer = audioPlayer else { return }
        
        let currentTime = audioPlayer.currentTime
        let newTime = currentTime + 15.0
        
        if newTime < audioPlayer.duration {
            audioPlayer.currentTime = newTime
        } else {
            audioPlayer.currentTime = audioPlayer.duration
        }
        updateProgress()
    }
    
    func backward() {
        guard let audioPlayer = audioPlayer else { return }
        
        let currentTime = audioPlayer.currentTime
        let newTime = currentTime - 15.0
        
        if newTime > 0 {
            audioPlayer.currentTime = newTime
        } else {
            audioPlayer.currentTime = 0
        }
        updateProgress()
    }
    
    func updateSliderValue(_ slider: UISlider) {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.currentTime = TimeInterval(slider.value)
        updateProgress()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgress() {
        guard let audioPlayer = audioPlayer else { return }
        
        NotificationCenter.default.post(name: .updateProgress, object: self, userInfo: ["currentTime": audioPlayer.currentTime, "duration": audioPlayer.duration])
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension PlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        NotificationCenter.default.post(name: .audioPlayerDidFinishPlaying, object: self)
    }
}

extension Notification.Name {
    static let updateProgress = Notification.Name("updateProgress")
    static let audioPlayerDidFinishPlaying = Notification.Name("audioPlayerDidFinishPlaying")
}
