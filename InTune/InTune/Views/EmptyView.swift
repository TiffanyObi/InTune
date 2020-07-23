//
//  EmptyView.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class EmptyView: UIView {
     private lazy var messageLabel: UILabel = {
            let label = UILabel()
            label.text = "User Reported"
            label.font = UIFont(name: "Didot", size: 24)
            label.numberOfLines = 6
            label.textAlignment = .center
            return label
        }()
       
    
        init(message: String) {
            super.init(frame: UIScreen.main.bounds)
            
            messageLabel.text = message
            commonInit()
        }
            required init?(coder: NSCoder) {
                super.init(coder:coder)
                commonInit()
            }
            
            private func commonInit() {
                setUpMessageLabelConstraints()
            }
        
        private func setUpMessageLabelConstraints(){
            addSubview(messageLabel)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([
             
                messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                messageLabel.topAnchor.constraint(equalTo: topAnchor, constant:  200)
            
            
            ])
                
            }

}
