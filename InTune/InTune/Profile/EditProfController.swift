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
    
    var biotext:String?
    var userName:String?
    
    private let storageService = StorageService()
    let db = DatabaseService()
    
    var artist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        updateUI()
        usernameTextField.delegate = self
        bioTextView.delegate = self
        getArtist()
    }
    
    private func setUpUI() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: usernameTextField.frame.height - 2, width: usernameTextField.frame.width, height: 2)
        bottomLayer.backgroundColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
        usernameTextField.borderStyle = .none
        usernameTextField.layer.addSublayer(bottomLayer)
    }
    
    func getArtist(){
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        db.fetchArtist(userID: userID) { [weak self](result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                
            case.success(let artist1):
                self?.artist = artist1
                self?.usernameTextField.text = artist1.name
                self?.bioTextView.text = artist1.bioText ?? "Enter Bio Here"
                
            }
        }
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
        
        if user.photoURL == nil  {
            editImageView.image = UIImage(systemName: "person.crop.square")
        } else {
            editImageView.kf.setImage(with: user.photoURL)
        }
        
        userName = "\(user.displayName ?? "")"
        
    }
    
    func updateInfo() {
        guard let userName = userName, !userName.isEmpty, let selectedImage = editImageView.image, let bioText = biotext else {

            showAlert(title: "Error editing", message: "Please check all fields")
            return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: editImageView.bounds)
        
        print("orig \(selectedImage.size) not orig \(resizedImage)")
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        db.updateDisplayName(name: userName) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error updating name", message: "\(error.localizedDescription)")
            case .success:
                print(true)
            }
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
                //update pic url
                self?.db.updateUserPhoto(user, photoURL: url.absoluteString, completion: { (result) in
                    switch result {
                    case.failure(let error):
                        print(error.localizedDescription)
                    case.success:
                        print(true)
                    }
                })
                request?.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing profile error: \(error.localizedDescription)")
                        }
                    } else {
                        //maybe nest functions
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Update", message: "Profile successfully updated")
                        }
                    }
                    
                })
                
            }
        }
        
        
        db.updateBio(bioText: bioText) { [weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error updating bio", message: error.localizedDescription)
                }
                
            case .success:
                print(true)
            }
        }
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        updateInfo()
    }
    
    
}

extension EditProfController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard !(textField.text?.isEmpty ?? true) else { return}
        userName = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        biotext = textView.text
    }
    func textViewShouldReturn(_ textView: UITextField) -> Bool {
        textView.resignFirstResponder()
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
