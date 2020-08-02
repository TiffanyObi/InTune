//
//  ShowAlert.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    public func signOutAction(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
            do {
                try Auth.auth().signOut()
                UIViewController.showViewController(storyboardName: "LoginView", viewControllerID: "LoginViewController")
            } catch {
                self.showAlert(title: "Error Signing Out", message: " \(error.localizedDescription)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
}
