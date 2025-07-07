//
//  File.swift
//  Neon
//
//  Created by Tyler Blackford on 3/19/25.
//



import Foundation
import UIKit
import AVFoundation
import Photos

public class NeonImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var completionHandler: ((UIImage?) -> Void)?
    public static let shared = NeonImagePickerManager()
    private var viewController: UIViewController?

    private var cameraPermissionDenied = false
    private var photoLibraryPermissionDenied = false

    public func configure(with viewController: UIViewController) {
        self.viewController = viewController
    }

    public func pickImage(completion: @escaping (UIImage?) -> Void) {
        completionHandler = completion

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.overrideUserInterfaceStyle = .dark

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.handleCameraSelection()
            }
            alertController.addAction(cameraAction)
        }

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.handlePhotoLibrarySelection()
        }
        alertController.addAction(photoLibraryAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        viewController?.present(alertController, animated: true, completion: nil)
    }

    private func handleCameraSelection() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showImagePicker(sourceType: .camera)
                    } else {
                        self.cameraPermissionDenied = true
                        self.showCameraPermissionAlert()
                    }
                }
            }
        case .authorized:
            showImagePicker(sourceType: .camera)
        case .denied, .restricted:
            cameraPermissionDenied = true
            showCameraPermissionAlert()
        @unknown default:
            break
        }
    }

    private func handlePhotoLibrarySelection() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self.showImagePicker(sourceType: .photoLibrary)
                    } else {
                        self.photoLibraryPermissionDenied = true
                        self.showPhotoLibraryPermissionAlert()
                    }
                }
            }
        case .authorized, .limited:
            showImagePicker(sourceType: .photoLibrary)
        case .denied, .restricted:
            photoLibraryPermissionDenied = true
            showPhotoLibraryPermissionAlert()
        @unknown default:
            break
        }
    }

    private func showCameraPermissionAlert() {
        let alert = UIAlertController(title: "Camera Access Needed", message: "Please allow camera access in Settings to take photos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        viewController?.present(alert, animated: true)
    }

    private func showPhotoLibraryPermissionAlert() {
        let alert = UIAlertController(title: "Photo Library Access Needed", message: "Please allow photo library access in Settings to choose photos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        viewController?.present(alert, animated: true)
    }

    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self

        if sourceType == .camera {
            imagePickerController.cameraCaptureMode = .photo
        }

        viewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            completionHandler?(image)
        } else {
            completionHandler?(nil)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        completionHandler?(nil)
    }
}
