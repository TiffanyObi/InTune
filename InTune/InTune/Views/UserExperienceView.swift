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
       label.font = UIFont(name: "Didot", size: 30)
       label.text = "Welcome!!! Choose the option that best describes you!"
        label.numberOfLines = 0
    label.textAlignment = .center
       return label
   }()
    
    private (set) lazy var artistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Aspiring Artist", for: .normal)
        button.backgroundColor = .purple
        button.tag = 0
        return button
    }()
    
    private (set) lazy var enthusiastButton: UIButton = {
        let button = UIButton()
         button.setTitle("A Supportive Enthusiast", for: .normal)
        button.backgroundColor = .purple
        button.tag = 1
        return button
    }()
        public lazy var allButtons: [UIButton] = {
            let buttons = [artistButton,enthusiastButton]
            return buttons
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
            setUpArtistButtonConstraints()
            setUpEnthusiastButtonConstraints()
        }
    
    func setUpWelcomeLabelConstraints(){
        addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    func setUpArtistButtonConstraints(){
        addSubview(artistButton)
        artistButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artistButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 50),
            artistButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            artistButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            artistButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
            
        ])
    }
    
    func setUpEnthusiastButtonConstraints(){
        addSubview(enthusiastButton)
        enthusiastButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            enthusiastButton.topAnchor.constraint(equalTo: artistButton.bottomAnchor, constant: 50),
            enthusiastButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            enthusiastButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            enthusiastButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
            
        ])
    }
}
