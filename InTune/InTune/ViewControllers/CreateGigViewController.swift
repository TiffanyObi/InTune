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
    
    
    
    
    
    //    let user: Artist
    //    //based on bool
    //    let gigId: String
    //    let title: String
    //    let descript: String
    //    let photoURL: String
    //    let price: Int
    //    let eventDate: String
    //    let createdDate: Timestamp
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        dateTextField.delegate = self
        priceTextField.delegate = self
        descriptionTextView.delegate = self
        addGestures()
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
            !description.isEmpty else {
                print("missing fields")
                return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Inconplete Profile", message: "Please complete your profile")
            return
        }
        
        
        
        
        self.dismiss(animated: true)
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
