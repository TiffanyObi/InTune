//
//  MessengerViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

/*
 add password change + email change
 add tag cv
 */

class EditProfController: UIViewController {

    @IBOutlet private var editImageView: DesignableImageView!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var bioTextField: UITextView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    public var editSelectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func changeProfImagePressed(_ sender: UIButton) {
        //photo library
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
}

extension EditProfController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
}
