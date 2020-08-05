//
//  DonateViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 8/3/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

protocol DisplayDonationShowAlert: AnyObject {
    func didDisplayShowAlert(donateViewController:DonateViewController)
}

import UIKit
import SafariServices
class DonateViewController: UIViewController {
    
    @IBOutlet weak var zelleView: UIView!
    @IBOutlet weak var zelleImageView: UIImageView!
    
    @IBOutlet weak var cashappView: UIView!
    @IBOutlet weak var cashappImageView: UIImageView!
    
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text  = "Please Send Donations To \n \" Tiffany Obi \" \n 347 - 415 - 9280 "
        label.textColor = .white
        label.font = UIFont(name: "Didot", size: 35.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(zelleViewUpdate))
        return gesture
    }()
 private lazy var tapGesture1: UITapGestureRecognizer = {
     let gesture = UITapGestureRecognizer()
     gesture.addTarget(self, action: #selector(cashappViewUpdate))
     return gesture
 }()
    private lazy var tapGesture2: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(backToNormal))
        return gesture
    }()
    
    var infoIsShowing = false
    weak var showAlertDelegate: DisplayDonationShowAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zelleImageView.addGestureRecognizer(tapGesture)
        cashappImageView.addGestureRecognizer(tapGesture1)
        zelleImageView.isUserInteractionEnabled = true
        cashappImageView.isUserInteractionEnabled = true
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    
        showAlertDelegate?.didDisplayShowAlert(donateViewController: self)
    }
    
    @objc private func updateViewWithInfo(view: UIView){
        
      
            if !infoIsShowing {
                rotationAnimations()
            }

        
    }
    
    @objc func zelleViewUpdate(sender:UITapGestureRecognizer){

        
        updateViewWithInfo(view: zelleView)

    }
    
    @objc func cashappViewUpdate(sender:UITapGestureRecognizer){
        
        let directCashappUrlString = "https://cash.app/$TiffanyObi"
        
        guard let url = URL(string: directCashappUrlString) else {return}
        
       let vC = SFSafariViewController(url: url)
        
                 present(vC,animated: true)
      
    
      }
    
    private func rotationAnimations(){
        let duration: Double = 2.0
          let curveOption: UIView.AnimationOptions = .curveEaseInOut
          
        UIView.transition(with: zelleView, duration: duration, options: [.transitionFlipFromRight,curveOption], animations: {
            self.zelleView.backgroundColor = .black
            self.zelleImageView.isHidden = true
            self.infoLabel.isHidden = false
            self.zelleView.addSubview(self.infoLabel)
            self.infoLabel.addGestureRecognizer(self.tapGesture2)
            self.infoLabel.isUserInteractionEnabled = true
            self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
                         
                         NSLayoutConstraint.activate([
                            self.infoLabel.topAnchor.constraint(equalTo: self.zelleView.topAnchor, constant: 20),
                            self.infoLabel.leadingAnchor.constraint(equalTo: self.zelleView.leadingAnchor, constant: 20),
                            self.infoLabel.trailingAnchor.constraint(equalTo: self.zelleView.trailingAnchor, constant: -20),
                            self.infoLabel.bottomAnchor.constraint(equalTo: self.zelleView.bottomAnchor, constant: -20)
                         ])
                     }, completion: nil)
      }
    
    @objc private func backToNormal(){
      let duration: Double = 2.0
        let curveOption: UIView.AnimationOptions = .curveEaseInOut
        
      UIView.transition(with: zelleView, duration: duration, options: [.transitionFlipFromRight,curveOption], animations: {
        self.zelleView.backgroundColor = .black
          self.infoLabel.isHidden = true
          self.zelleImageView.isHidden = false
        self.zelleImageView.addGestureRecognizer(self.tapGesture)
        
      }, completion: nil)
    }

}
