//
//  LoginViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var loginStateLabel: UILabel!
    
    @IBOutlet weak var loginStateButton: UIButton!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    private var accountState: AccountState = .existingUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loginView
        setUpTextfieldDelegates()
         clearErrorLabel()
        view.addGestureRecognizer(tapGesture)
    }
    
    
    private func setUpTextfieldDelegates(){
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
   @objc private func resignTextfeilds(){
        errorMessageLabel.isHidden = true
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    private func clearErrorLabel(){
        
        errorMessageLabel.text = ""
        errorMessageLabel.isHidden = true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text,
            !email.isEmpty,
            let password = passwordTextfield.text,
            !password.isEmpty else {
                showAlert(title: "Missing Fields", message: "Please fill all missing fields")
                print("missing feilds")
                return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        if accountState == .existingUser {
            loginButton.setTitle("LOGIN", for: .normal)
            loginStateLabel.text = "Don't have an account?"
            loginStateButton.setTitle("SIGN UP", for: .normal)
            
        } else {
            loginButton.setTitle("SIGN UP", for: .normal)
            loginStateLabel.text = "Already have an account ?"
            loginStateButton.setTitle("LOGIN", for: .normal)
            
        }
    }
    
    private func continueLoginFlow(email:String,password:String) {
        if accountState == .existingUser {
            print("existing user \(email) - \(password)")
          
        } else {
            print("new user")
        }
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
        print("create database user")
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerID: "ProfileViewController")
    }
    
    
  

}

extension LoginViewController: UITextFieldDelegate {
    
}
