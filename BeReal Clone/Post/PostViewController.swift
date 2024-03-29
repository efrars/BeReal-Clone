//
//  PostViewController.swift
//  BeReal Clone
//
//  Created by Efrain Rodriguez on 2/22/23.
//

import UIKit
import ParseSwift
import PhotosUI

class PostViewController: UIViewController {

    
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    
   private var pickedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPickedImageTapped(_ sender: Any) {
        
        // Create a configuration object
        var config = PHPickerConfiguration()
        
        // Set the filter to only show images as options
        
        config.filter = .images
        
        // Request the original file formal. Fastest method as it avoids transcoding
        
        config.preferredAssetRepresentationMode = .current
        
        // Only allow 1 image to be select at a time
        
        config.selectionLimit = 1
        
        // Instantiate a picker, passing in the configuration
        
        let picker = PHPickerViewController(configuration: config)
        
            // Set the picker delegate so we can receive whatever image the user picks
        picker.delegate = self
        
        // Present the picker
        
        present(picker,animated: true)
    }
    
    
    
    @IBAction func takePhotoTapped(_ sender: Any) {
        
        // Verifying that camera is available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
               return
        }
        
        // Instantiating the image picker
        let imagePicker = UIImagePickerController()
        
        // Shows the camera (vs. photo Library)
        
        imagePicker.sourceType = .camera
        
            // Allows user to edit image withing image picker flow (i.e crop, etc)
        imagePicker.allowsEditing = true
        
        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        
        imagePicker.delegate = self
        
        // Present the image picker (camera)
        present(imagePicker, animated: true)
        
    }
    
    
    @IBAction func onShareTapped(_ sender: Any) {
        
        // Dismiss Keyboard
        
        view.endEditing(true)
        
        // Create and save Post
        
            // Unwrap optional pickedImage
        
        guard let image = pickedImage,
              // Create and compress image data (jpeg) rom UIImage
              
                let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        let imageFile = ParseFile(name:"image.jpg", data:imageData)
        
        // Create a Post Object
        
        var post = Post()
        
        // Set the properties
        post.imageFile = imageFile
        post.caption = captionTextField.text
        
        // Set the user as the current user
        post.user = User.current
        
        // Save the object in background(async)
        
        post.save {[weak self] result in
            
            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")
                    
                    // Return to the previous view controller
                    self?.navigationController?.popViewController(animated: true)
                    
                    if var currentUser = User.current {
                        
                        currentUser.lastPostedDate = Date()
                        
                        // Save updates to user (async)
                        
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")
                                
                                DispatchQueue.main.async {
                                    self?.navigationController?.popViewController(animated: true)
                                }
                                
                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }
                    
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}



extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // Dismiss the picker
        
        picker.dismiss(animated: true)
        
        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make suer the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // Load a UIImage from the provider
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                // ❌ Unable to cast to UIImage
                self?.showAlert()
                return
                
            }
            
            // Check for and handle any errors
            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            } else {
                // UI updates (like setting image on image view) should be done on main thread
                DispatchQueue.main.async {
                    
                    // Set image on preview image view
                    self?.previewImageView.image = image
                    
                    // Set image to use when saving post
                    self?.pickedImage = image
                }
            }
            
        }
    }
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the image picker
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("❌📷 Unable to get image")
                    return
        }
        
        previewImageView.image = image
        
        pickedImage = image
        
    }
}
