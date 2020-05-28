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
    
    @IBOutlet private var emailTextfield: UITextField!
    @IBOutlet private var passwordTextfield: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var loginStateLabel: UILabel!
    @IBOutlet private var loginStateButton: UIButton!
    @IBOutlet private var errorMessageLabel: UILabel!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    private var dataBaseService = DatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
           authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
                   switch result {
                   case .failure(let error):
                       print(error)
                       DispatchQueue.main.async {
                           self?.errorMessageLabel.isHidden = false
                        self?.errorMessageLabel.text = "Incorrect Login: \(error.localizedDescription)"
                        self?.errorMessageLabel.textColor = .white
                       }
                   case .success:
                       DispatchQueue.main.async {
                           //navigate to main view
                           self?.navigateToMainView()
                       }
                   }
               }
           } else {
            
                authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                        DispatchQueue.main.async {
                            self?.errorMessageLabel.isHidden = false
                            self?.errorMessageLabel.text = "Error: \(error.localizedDescription)"
                            self?.errorMessageLabel.textColor = .white
                        }
                    case .success(let authDataResult):
                        print(authDataResult.user.email ?? "user email")
//                        self?.createDatabaseUser(authDataResult: authDataResult)
                    }
                }
            }
           
        }
    
    
//    private func createDatabaseUser(authDataResult: AuthDataResult) {
//
//        dataBaseService.createArtist(artist: <#T##Artist#>, authDataResult: <#T##AuthDataResult#>, completion: <#T##(Result<Bool, Error>) -> ()#>){[weak self] (result) in
//            switch result {
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.showAlert(title: "Account Error", message: error.localizedDescription)
//                }
//            case .success:
//                self?.navigateToMainView()
//            }
//        }
//    }
//
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerID: "MainViewTabBarController")
    }
    
    
  

}

extension LoginViewController: UITextFieldDelegate {
    
}
