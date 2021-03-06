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
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet public var emailTextfield: UITextField!
    @IBOutlet public var passwordTextfield: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var loginStateLabel: UILabel!
    @IBOutlet private var loginStateButton: UIButton!
  
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    public var accountState: AccountState = .existingUser
    public var authSession = AuthenticationSession()
    private var dataBaseService = DatabaseService()
    
    let viewModel = LoginViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        appLogoImageView.layer.cornerRadius = (appLogoImageView.bounds.width/2)
        loginButton.shadowLayer(loginButton)
        loginStateButton.shadowLayer(loginStateButton)
        pulsatingAnimation()
        setUpTextfieldDelegates()
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpTextfieldDelegates(){
        emailTextfield.delegate = self
        emailTextfield.textFieldShadow()
        passwordTextfield.delegate = self
        passwordTextfield.textFieldShadow()
    }
   @objc private func resignTextfeilds(){
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text,
            !email.isEmpty,
            let password = passwordTextfield.text,
            !password.isEmpty else {
                showAlert(title: viewModel.missingFields, message: viewModel.missingFieldsMessage)
                
                return
        }
        viewModel.loginFlow(email: email, password: password, loginVC: self)
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
    private func pulsatingAnimation() {
           UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
               // animation block here
            self.appLogoImageView.alpha = 1
               self.appLogoImageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
               
           }) { (done) in
               UIView.animate(withDuration: 0.7)  {
                   self.appLogoImageView.transform =
                   CGAffineTransform.identity
                
                self.rotationAnimations()
               }
           }
       }
    private func rotationAnimations(){
        let duration: Double = 10.0
        let curveOption: UIView.AnimationOptions = .curveEaseInOut
        
        UIView.transition(with: appLogoImageView, duration: duration, options: [.transitionFlipFromRight,curveOption], animations: nil, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignTextfeilds()
        return true
    }
}
