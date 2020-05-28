//
//  LoginViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var loginStateLabel: UILabel!
    
    @IBOutlet weak var loginStateButton: UIButton!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTextfieldDelegates()
         errorMessageLabel.isHidden = true
    }
    
    
    private func setUpTextfieldDelegates(){
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    private func clearErrorLabel(){
        
        errorMessageLabel.text = ""
    }
  

}

extension LoginViewController: UITextFieldDelegate {
    
}
