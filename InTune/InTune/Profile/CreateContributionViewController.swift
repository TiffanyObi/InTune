//
//  CreateContributionViewController.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 8/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class CreateContributionViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var donationTextField: UITextField!
    @IBOutlet var yesButton: UIButton!
    var show = true
    var db = DatabaseService()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfields))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yesButton.shadowLayer(yesButton)
        yesButton.layer.borderWidth = 2
        setUpTextFields()
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpTextFields() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        donationTextField.delegate = self
    }
    
    @objc private func resignTextfields() {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        donationTextField.resignFirstResponder()
    }
    
    private func createContributor() {
        
        guard let name = nameTextField.text, !name.isEmpty, let email = emailTextField.text, !email.isEmpty else {
            DispatchQueue.main.async {
                self.showAlert(title: "Missing Fields", message: "Please check all text fields")
            }
            return
        }
        
        if let donation = donationTextField.text {
            db.createContributor(name: name, email: email, amountDonated: Double(donation)) { (result) in
                
                switch result {
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                case .success:
                    print("created contributor")
                }
            }
        } else {
        db.createContributor(name: name, email: email, amountDonated: nil) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            case .success:
                DispatchQueue.main.async {
                self?.showAlert(title: "Thank you!", message: "Feel free to check out the Contributors page for your name!")
                }
            }
        }
        }
        
    }
    
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        createContributor()
        dismiss(animated: true, completion: nil)
    }
    
    private func resetUI(_ button: UIButton) {
        button.layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 0
    }
    
}
extension CreateContributionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
