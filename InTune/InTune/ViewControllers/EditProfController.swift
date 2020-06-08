//
//  MessengerViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
/*
 add password change + email change
 add tag cv
 */

class EditProfController: UIViewController {
    
    @IBOutlet private var editImageView: DesignableImageView!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var bioTextView: UITextView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    public var selectedImage: UIImage? {
        didSet{
            editImageView.image = selectedImage
        }
    }
    
    private let storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        updateUI()
    }
    
    
    @IBAction func changeProfImagePressed(_ sender: UIButton) {
        //photo library
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        //set image with kf
        editImageView.kf.setImage(with: user.photoURL)
        
    }
    
    func updateInfo() {

        guard let userName = usernameTextField.text, !userName.isEmpty, let selectedImage = editImageView.image, let bioText = bioTextView.text else {
            showAlert(title: "Error editing", message: "Please check all fields")
            return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: editImageView.bounds)
        
        print("orig \(selectedImage.size) not orig \(resizedImage)")
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        storageService.uploadPhoto(userId: user.uid, itemId: "123", image: resizedImage){ [weak self] (result) in
            
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error uploading image", message: "\(error.localizedDescription)")
            case .success(let url):
                print("\(url)")
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = userName
                request?.photoURL = url
                request?.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing profile error: \(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Update", message: "Profile successfully updated")
                        }
                    }
                    
                })
                
            }
        }
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        updateInfo()
    }
    
    
}

extension EditProfController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        dismiss(animated: true)
    }
    
}
