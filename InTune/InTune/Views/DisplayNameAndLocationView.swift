//
//  DisplayNameAndLocationView.swift
//  InTune
//
//  Created by Tiffany Obi on 6/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class DisplayNameAndLocationView: UIView {
    
    private lazy var displayNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Please create your unique username"
        label.font = UIFont(name: "Didot", size: 30.0)
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public lazy var displayNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.placeholder = "Enter Display Name"
        return textfield
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Where are you located?"
         label.font = UIFont(name: "Didot", size: 30.0)
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    public lazy var locationPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    public lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("N E X T", for: .normal)
        button.backgroundColor = .purple
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commomInit()
    }
    
    private func commomInit() {
        setUpDisplayNameLabel()
        setUpDisplayNameTextField()
        setUpLocationLabel()
        setUpLocationPickerView()
        setUpNextButton()
    }
    
    func setUpDisplayNameLabel(){
        addSubview(displayNameLabel)
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            displayNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            displayNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            displayNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    
    func setUpDisplayNameTextField(){
        addSubview(displayNameTextfield)
        displayNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            displayNameTextfield.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 40),
            displayNameTextfield.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            displayNameTextfield.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            displayNameTextfield.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05)
            
        ])
    }
    func setUpLocationLabel(){
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: displayNameTextfield.bottomAnchor, constant: 100),
            locationLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setUpLocationPickerView(){
        addSubview(locationPickerView)
        locationPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationPickerView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 40),
            locationPickerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            locationPickerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            locationPickerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35)
        ])
    }
    
    func setUpNextButton(){
        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: locationPickerView.bottomAnchor, constant: 50),
            nextButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 75),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -100),
            nextButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10)
        
        
        ])
    }
    
    
}
