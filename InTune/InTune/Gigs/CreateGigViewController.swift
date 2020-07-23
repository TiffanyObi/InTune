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
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet var locationPicker: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let databaseService = DatabaseService()
    
    private let storageService = StorageService()
    
    var currentUser: Artist?
    
    var date: Date?
    
    let states = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    
    var location: String!
    
    private var selectedImage: UIImage? {
        didSet {
            gigImageView.image = selectedImage
        }
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfield(_:)))
        return gesture
    }()
    
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
    
    var textCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI(titleTextField)
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        datePicker.minimumDate = Date()
        priceTextField.delegate = self
        descriptionTextView.delegate = self
        locationPicker.delegate = self
        locationPicker.dataSource = self
        addGestures()
        updateCurrentArtist()
        view.addGestureRecognizer(tapGesture)
        location = states.first
    }
    
    private func setUpUI(_ item: UITextField) {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: item.frame.height - 2, width: item.frame.width, height: 2)
        bottomLayer.backgroundColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
        item.borderStyle = .none
        item.layer.addSublayer(bottomLayer)
    }
    
    func updateCurrentArtist() {
        guard let currentUser = Auth.auth().currentUser else {return}
        databaseService.fetchArtist(userID: currentUser.uid) { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
            case .success(let artist):
                self?.currentUser = artist
            }
        }
    }
    
    private func addGestures() {
        gigImageView.isUserInteractionEnabled = true
        gigImageView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func resignTextfield(_ gesture: UITapGestureRecognizer){
        guard let count = textCount else { return }
        guard count < 20 else {
                self.showAlert(title: "Limit Reached", message: "Title cannot be longer than 20 characters")
            return
        }
        titleTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
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
    
    @IBAction func datePickerUsed(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        print("submit button pressed")
        //let selectedImage = selectedImage,
        guard let title = titleTextField.text,
            !title.isEmpty, let count = textCount,
            let price = priceTextField.text,
            !price.isEmpty,
            let date = date,
            let description = descriptionTextView.text,
            !description.isEmpty,
            let location = location,
            !location.isEmpty,
            let artist = currentUser else {
                showAlert(title: "Missing Fields", message: "Please review that all fields are complete")
                return
        }
        
        guard count < 20 else {
                self.showAlert(title: "Limit Reached", message: "Title cannot be longer than 20 characters")
            return
        }
        
        //        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: gigImageView.bounds)
        
        databaseService.createGig(artist: artist, title: title, description: description, price: Int(price) ?? 0, eventDate: date.string(with: "MMM d, h:mm a"), createdDate: Timestamp(), location: location) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Posting Error", message: "Could not post gig: \(error.localizedDescription)")
            case .success:
                //                self.uploadPhoto(photo: resizedImage, documentId: documentID)
                print("posted gig")
                
                self?.databaseService.createGigPost(artist: artist, title: title, description: description, price: Int(price) ?? 0, eventDate: date.string(with: "MMM d, h:mm a"), createdDate: Timestamp(), location: self?.location ?? "no city") { (result) in
                    
                    switch result {
                    case .failure(let error):
                        self?.showAlert(title: "Posting Error", message: "Could not post gig: \(error.localizedDescription)")
                    case .success:
                        print("posted gig to artist")
                    }
                }
            }
            
        }
        dismiss(animated: true)
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
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        showPhotoOptions()
    }
    
    
}

extension CreateGigViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return states.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return states[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location = states[row]
        print(location!)
    }
    
}

extension CreateGigViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textCount = text.count
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if text.count > 20 {
            self.showAlert(title: "Limit Reached", message: "Title cannot be longer than 20 characters")
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

extension CreateGigViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
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

