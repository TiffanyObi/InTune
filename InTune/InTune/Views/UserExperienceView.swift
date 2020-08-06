//
//  UserExperienceView.swift
//  InTune
//
//  Created by Tiffany Obi on 6/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class UserExperienceView: UIView {
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 30)
        label.text = "Welcome"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    
    private lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 18)
        label.text = "Choose an option that best fits you"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    private (set) lazy var artistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Artist", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tag = 0
        return button
    }()
    
    private (set) lazy var enthusiastButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enthusiast", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tag = 1
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
        setUpWelcomeLabelConstraints()
        setUpPromptConstraints()
        configureArtistButton()
        configureEnthusiastButton()
    }
    
    func setUpWelcomeLabelConstraints(){
        addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120),
            welcomeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    func setUpPromptConstraints() {
        addSubview(promptLabel)
        
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promptLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            promptLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            promptLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor)
        ])
    }
    
    func configureArtistButton() {
        addSubview(artistButton)
        artistButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistButton.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 40),
            artistButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configureEnthusiastButton() {
        addSubview(enthusiastButton)
        enthusiastButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enthusiastButton.topAnchor.constraint(equalTo: artistButton.bottomAnchor, constant: 60),
            enthusiastButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
