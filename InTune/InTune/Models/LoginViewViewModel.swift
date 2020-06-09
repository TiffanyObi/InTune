//
//  FavoriteVideo.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

struct LoginViewViewModel {
    
//    private var authSession = AuthenticationSession()
//    private var accountState: AccountState = .existingUser
    private var database = DatabaseService()
    public var userExperienceView = UserExperienceView()
    var loginButtonTitle: String {
        return "LOGIN"
    }
    var signUpButtonTitle:String {
        return "SIGN UP"
    }
    
    var newAccountMessage:String{
        return "Don't have an account?"
    }
    
    var exisistingAccountMessage: String {
        return "Already have an account ?"
    }
    var missingFields:String {
        return "Missing Fields"
    }
    var missingFieldsMessage:String {
        return "Please fill all missing fields"
    }
    var setErrorLabelToEmpty:String{
        return ""
    }
    func loginFlow(email:String,password:String,loginVC:LoginViewController) {
        
        if loginVC.accountState == .existingUser {
            loginVC.authSession.signExistingUser(email: email, password: password) { (result) in
                           switch result {
                           case .failure(let error):
                               print(error)
                               DispatchQueue.main.async {
                                loginVC.errorMessageLabel.isHidden = false
                                loginVC.errorMessageLabel.text = "Incorrect Login: \(error.localizedDescription)"
                                loginVC.errorMessageLabel.textColor = .white
                                
                               }
        
                           case .success:
                               DispatchQueue.main.async {
                                   //navigate to main view
                                self.navigateToMainView()
                               }
                           }
                       }
                   } else {
                    
            loginVC.authSession.createNewUser(email: email, password: password) { (result) in
                            switch result {
                            case .failure(let error):
                                print(error)
                                DispatchQueue.main.async {
                                    loginVC.errorMessageLabel.isHidden = false
                                   loginVC.errorMessageLabel.text = "Error: \(error.localizedDescription)"
                                    loginVC.errorMessageLabel.textColor = .white
                                }
                            case .success(let authDataResult):
                                print(authDataResult.user.email ?? "user email")
     
                                self.createDatabaseUser(authDataResult)
                                self.navigateToOnboardView()

                            }
                        }
                    }
                   
                }
    
    private func createDatabaseUser(_ authDataResult:AuthDataResult){
        
        database.createArtist(authDataResult: authDataResult) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success:
             print(true)
           
            }
        }
        
    }
        
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerID: "MainViewTabBarController")
    }
    
    private func navigateToOnboardView(){
        UIViewController.showViewController(storyboardName: "OnboardingView", viewControllerID: "OnboardingViewController")
    }
    
//    private func changeToExperienceView(viewController: UIViewController) {
//        
//        viewController.view = userExperienceView
//        userExperienceView.backgroundColor = .systemGroupedBackground
//
//
//    }
    
   
    
    
    }

