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
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet public var emailTextfield: UITextField!
    @IBOutlet public var passwordTextfield: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var loginStateLabel: UILabel!
    @IBOutlet private var loginStateButton: UIButton!
    @IBOutlet public var errorMessageLabel: UILabel!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    private var dataBaseService = DatabaseService()
    let viewModel = LoginViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pulsatingAnimation()
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
        
        errorMessageLabel.text = viewModel.setErrorLabelToEmpty
        errorMessageLabel.isHidden = true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text,
            !email.isEmpty,
            let password = passwordTextfield.text,
            !password.isEmpty else {
                showAlert(title: viewModel.missingFields, message: viewModel.missingFieldsMessage)
                
                return
        }
        viewModel.loginFlow(email: email, password: password)
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        if accountState == .existingUser {
            loginButton.setTitle(viewModel.loginButtonTitle, for: .normal)
            loginStateLabel.text = viewModel.newAccountMessage
            loginStateButton.setTitle(viewModel.signUpButtonTitle, for: .normal)
            
        } else {
            loginButton.setTitle(viewModel.signUpButtonTitle, for: .normal)
            loginStateLabel.text = viewModel.exisistingAccountMessage
            loginStateButton.setTitle(viewModel.loginButtonTitle, for: .normal)
            
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

    
    private func pulsatingAnimation() {
           UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
               // animation block here
               
               self.appNameLabel.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
               
           }) { (done) in
               // code to be executed after animation completes
               //option1 - you can reset view's values
               //option2 - creates a next animation
               
               UIView.animate(withDuration: 0.7)  {
                   self.appNameLabel.transform =
                   CGAffineTransform.identity
                
                self.rotationAnimations()
               }
           }
       }
    private func rotationAnimations(){
        let duration: Double = 10.0
        let curveOption: UIView.AnimationOptions = .curveEaseInOut
        
        UIView.transition(with: appNameLabel, duration: duration, options: [.transitionFlipFromRight,curveOption], animations: nil, completion: nil)
    }
  

}

extension LoginViewController: UITextFieldDelegate {
    
}
