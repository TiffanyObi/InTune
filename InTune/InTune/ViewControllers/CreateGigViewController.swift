//
//  CreateGigViewController.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class CreateGigViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var gigImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    let databaseService = DatabaseService()
    
    private let storageService = StorageService()
    
    var currentUser: Artist?
    
    private var selectedImage: UIImage? {
        didSet {
            gigImageView.image = selectedImage
        }
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        dateTextField.delegate = self
        priceTextField.delegate = self
        descriptionTextView.delegate = self
        addGestures()
        updateCurrentArtist()
    }
    
    func updateCurrentArtist() {
        guard let currentUser = Auth.auth().currentUser else {return}
        databaseService.fetchArtist(userID: currentUser.uid) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let artist):
                self.currentUser = artist
            }
        }
    }
    
    private func addGestures() {
        gigImageView.isUserInteractionEnabled = true
        gigImageView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibaray = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibaray)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        print("submit button pressed")
        
        guard let title = titleTextField.text,
            !title.isEmpty,
            let date = dateTextField.text,
            !date.isEmpty,
            let price = priceTextField.text,
            !price.isEmpty,
            let description = descriptionTextView.text,
            !description.isEmpty,
            let selectedImage = selectedImage else {
                print("missing fields")
                return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: gigImageView.bounds)
        
        
        
        databaseService.createGig(artist: currentUser!, title: title, description: description, price: Int(price) ?? 0, eventDate: date, createdDate: Timestamp()) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let documentId):
                self.uploadPhoto(photo: resizedImage, documentId: documentId)
            }
        }

    }
    
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto(itemId: documentId, image: photo) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self.updateItemImageURL(url, documentsId: documentId)
            }
        }
    }
    
    
    private func updateItemImageURL(_ url: URL, documentsId: String) {
        // update an existing document on firestore
        Firestore.firestore().collection(DatabaseService.gigPosts).document(documentsId).updateData(["imageURL" : url.absoluteString]) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
                }
            } else {
                print("all went well with the update")
                DispatchQueue.main.async {
                    self.showAlert(title: "succesfully uploaded photo", message: nil)
                }
            }
        }
    }
    
    
    
    
}

extension CreateGigViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CreateGigViewController: UITextViewDelegate {
    
    
}

extension CreateGigViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not attain original image")
        }
        selectedImage = image
        dismiss(animated: true, completion: nil)
    }
    
}

