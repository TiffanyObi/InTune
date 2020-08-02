//
//  CreateGigVC.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 7/17/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateGigVC: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    let databaseService = DatabaseService()
    
    var currentUser: Artist?
    
    var date: Date?
    
    let states = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    
    var location: String!
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.cornerRadius = 14
        updateCurrentArtist()
        titleTextField.delegate = self
        priceTextField.delegate = self
        descriptionTextView.delegate = self
        datePicker.minimumDate = Date()
        locationPicker.delegate = self
        locationPicker.dataSource = self
        location = states.first
        view.addGestureRecognizer(tapGesture)
        //add tap dismiss to tableview
        //add title count limit
    }
    @objc private func resignTextfeilds(){
        titleTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
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
    
    @IBAction func datePickerUsed(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        print("cancel button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func create(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            !title.isEmpty,
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
        let gigId = UUID().uuidString
        databaseService.createGig(artist: artist, title: title, description: description, price: Int(price) ?? 0, eventDate: date.string(with: "MMM d, h:mm a"), createdDate: Timestamp(), location: location, gigId: gigId) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Posting Error", message: "Could not post gig \(error.localizedDescription)")
                }
            case .success:
                self.databaseService.createGigPost(artist: artist, title: title, description: description, price: Int(price) ?? 0, eventDate: date.string(with: "MMM d, h:mm a"), createdDate: Timestamp(), location: location, gigId: gigId) { (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showAlert(title: "Could not post gig", message: "Error posting gig \(error.localizedDescription)")
                        }
                    case .success:
                        print("posted gig")
                    }
                }
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension CreateGigVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateGigVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
    }
}

extension CreateGigVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
   
    
    func textViewShouldReturn(_ textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}
