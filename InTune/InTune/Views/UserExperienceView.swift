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
        button.setTitle("   Aspiring Artist   ", for: .normal)
        button.backgroundColor = .purple
        button.tag = 0
        return button
    }()
    
    private (set) lazy var enthusiastButton: UIButton = {
        let button = UIButton()
         button.setTitle("  A Supportive Enthusiast  ", for: .normal)
        button.backgroundColor = .purple
        button.tag = 1
        return button
    }()
        public lazy var allButtons: [UIButton] = {
            let buttons = [artistButton,enthusiastButton]
            return buttons
        }()
    private lazy var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 2
        
        return stack
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
            setUpButtonStackView()
//            setUpArtistButtonConstraints()
//            setUpEnthusiastButtonConstraints()
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
    
    func setUpButtonStackView(){
        addSubview(buttonStack)
        buttonStack.addArrangedSubview(artistButton)
        buttonStack.addArrangedSubview(enthusiastButton)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
            buttonStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            buttonStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
        ])
        
    }
}
