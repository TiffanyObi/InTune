//
//  OnboardingViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    let userExperienece = UserExperienceView()
    let displayNameAndLocation = DisplayNameAndLocationView()
    let tagsSelectionView = TagsSelectionView()
    let database = DatabaseService()
    let states = StatesForPickerView.states
    var displayName = ""
    
    var userLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = userExperienece
        view.backgroundColor = .systemGroupedBackground
     setUpButtonOnExperienceView()
        setUpTextFeildFroDisplayNameView()
        setUoPickerViewForLocationView()
        setUpNextButton()
    }
    
    func setUpButtonOnExperienceView(){
        for button in userExperienece.allButtons {
            button.addTarget(self, action:#selector(chooseUserExperience), for: .touchUpInside)
        }
    }
    
    func setUpTextFeildFroDisplayNameView(){
        displayNameAndLocation.displayNameTextfield.delegate = self
    }
    
   func setUoPickerViewForLocationView(){
    displayNameAndLocation.locationPickerView.dataSource = self
    displayNameAndLocation.locationPickerView.delegate = self
    }
    
    func setUpNextButton(){
        displayNameAndLocation.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc func chooseUserExperience(_ sender: UIButton){
        
        switch sender.tag {
        case 0:
            database.updateUserExperience(isAnArtist: true) { [weak self](result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    
                case .success:

                    self?.navigateToDisplayNameAndCityView()
                }
            }
            
            
        case 1:
            database.updateUserExperience(isAnArtist: false) { [weak self](result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    
                case .success:

                    self?.navigateToDisplayNameAndCityView()
                }
            }
        default:
            print("i'm a guest")
        }
    }
    
    private func navigateToDisplayNameAndCityView(){
       view = displayNameAndLocation
        view.backgroundColor = .systemGroupedBackground
    }
    
    
    @objc private func nextButtonPressed(){
        database.updateUserDisplayNameAndLocation(userName: displayName, location: userLocation) { [weak self](result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                
            case.success:
                print(true)
                self?.navigateToTagsSelectionView()
            }
        }
    }
    
    private func navigateToTagsSelectionView(){
        view = tagsSelectionView
        view.backgroundColor = .purple
    }
}

extension OnboardingViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard !(textField.text?.isEmpty ?? true) else {return}
        
        displayName = textField.text ?? "no display name"
    }
    
    
    
}

extension OnboardingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
    
        userLocation = states[row]
    }
    
}
