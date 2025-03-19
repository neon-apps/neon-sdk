//
//  File.swift
//  Neon
//
//  Created by Tyler Blackford on 3/19/25.
//

import Foundation
import UIKit

public class NeonImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var completionHandler: ((UIImage?) -> Void)?
    static let shared = NeonImagePickerManager()
    private var viewController: UIViewController?

    public func configure(with viewController: UIViewController) {
        self.viewController = viewController
        print(viewController)
    }
    
    public func pickImage(completion: @escaping (UIImage?) -> Void) {
        completionHandler = completion
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.overrideUserInterfaceStyle = .dark
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.showImagePicker(sourceType: .camera)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
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
    
    // MARK: - UIImagePickerControllerDelegate
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         picker.dismiss(animated: true, completion: nil)

         if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
             completionHandler?(image)
         } else {
             completionHandler?(nil)
         }
     }

    public  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
         completionHandler?(nil)
     }
}
