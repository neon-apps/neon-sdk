//
//  RecordingManager.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//

import Foundation
import AVFoundation
import FirebaseStorage

class RecordingManager: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession?
    private var audioFileName: URL?
    private var uploadTask: StorageUploadTask?

    var onCompletion: ((URL?, Error?) -> Void)?
    static let shared = RecordingManager()
    
    private override init() {
        super.init()
        createRecordingsDirectory()
    }
    
    private func createRecordingsDirectory() {
        let recordingsDirectory = getDocumentsDirectory().appendingPathComponent("Recordings")
        if !FileManager.default.fileExists(atPath: recordingsDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create recordings directory: \(error.localizedDescription)")
            }
        }
    }

    func startRecording() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecordingSession()
                    } else {
                        self.onCompletion?(nil, NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "Microphone access denied"]))
                    }
                }
            }
        } catch {
            self.onCompletion?(nil, error)
        }
    }

    private func startRecordingSession() {
        let audioID = UUID().uuidString
        PlayerManager.shared.localAudioFileName = audioID
        audioFileName = getDocumentsDirectory().appendingPathComponent("Recordings").appendingPathComponent("\(audioID).wav")
        
        let settings: [String : Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            self.onCompletion?(nil, error)
        }
    }

    func stopRecording(localCompletion: @escaping (String?, Error?) -> Void, remoteCompletion: @escaping (URL?, Error?) -> Void) {
        audioRecorder?.stop()
        audioRecorder = nil

        guard let audioFileName = audioFileName else {
            localCompletion(nil, NSError(domain: "com.example.app", code: 2, userInfo: [NSLocalizedDescriptionKey: "Audio file URL is nil"]))
            remoteCompletion(nil, nil)
            return
        }

        // Verify file existence
        if !FileManager.default.fileExists(atPath: audioFileName.path) {
            localCompletion(nil, NSError(domain: "com.example.app", code: 3, userInfo: [NSLocalizedDescriptionKey: "Audio file does not exist at path: \(audioFileName.path)"]))
            remoteCompletion(nil, nil)
            return
        }

        localCompletion(getAudioId(), nil)
        print("Audio file exists at path: \(audioFileName.path)")
        self.uploadAudio(fileURL: audioFileName, completion: remoteCompletion)
    }

    private func uploadAudio(fileURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        do {
            let audioData = try Data(contentsOf: fileURL)
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let audioRef = storageRef.child("audios/\(UUID().uuidString).wav")
            
            uploadTask = audioRef.putData(audioData, metadata: nil) { metadata, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                audioRef.downloadURL { url, error in
                    completion(url, error)
                }
            }

            uploadTask?.observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                // Update loading indicator
            }

            uploadTask?.observe(.success) { snapshot in
                // Hide loading indicator
            }

            uploadTask?.observe(.failure) { snapshot in
                if let error = snapshot.error {
                    completion(nil, error)
                }
            }
        } catch {
            completion(nil, error)
        }
    }

    public func getLocalFileURL() -> URL? {
        guard let audioId = PlayerManager.shared.localAudioFileName else { return nil}
        return  getDocumentsDirectory().appendingPathComponent("Recordings").appendingPathComponent("\(audioId).wav")
    }
    
    public func getAudioId() -> String?{
        guard let audioId = PlayerManager.shared.localAudioFileName else { return nil}
        return  audioId
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func requestRecordPermission(completion: @escaping (Bool, AVAudioSession.RecordPermission) -> Void) {
        recordingSession = AVAudioSession.sharedInstance()
        let currentStatus = recordingSession?.recordPermission

        if currentStatus == .granted {
            completion(true, .granted)
        } else if currentStatus == .denied {
            completion(false, .denied)
        } else if currentStatus == .undetermined {
            DispatchQueue.main.async {
                completion(false, .undetermined)
            }
            
            recordingSession?.requestRecordPermission() { allowed in }
        }
    }
}
