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

    public func configure(with viewController: UIViewController) {
        self.viewController = viewController
    }

    public func pickImage(completion: @escaping (UIImage?) -> Void) {
        completionHandler = completion

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.overrideUserInterfaceStyle = .dark

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.checkCameraPermission()
            }
            alertController.addAction(cameraAction)
        }

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.checkPhotoLibraryPermission()
        }
        alertController.addAction(photoLibraryAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        viewController?.present(alertController, animated: true, completion: nil)
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showImagePicker(sourceType: .camera)
                    } else {
                        self.showPermissionAlert(for: "Camera")
                    }
                }
            }
        default:
            showPermissionAlert(for: "Camera")
        }
    }

    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            showImagePicker(sourceType: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self.showImagePicker(sourceType: .photoLibrary)
                    } else {
                        self.showPermissionAlert(for: "Photo Library")
                    }
                }
            }
        default:
            showPermissionAlert(for: "Photo Library")
        }
    }

    private func showPermissionAlert(for type: String) {
        let alert = UIAlertController(
            title: "Access Needed",
            message: "Please enable access to the \(type) in Settings to continue.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })

        viewController?.present(alert, animated: true, completion: nil)
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

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
