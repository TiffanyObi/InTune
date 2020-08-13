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
    
    @IBOutlet weak var cashappView: UIView!
    @IBOutlet weak var cashappImageView: UIImageView!
    
  
 private lazy var tapGesture: UITapGestureRecognizer = {
     let gesture = UITapGestureRecognizer()
     gesture.addTarget(self, action: #selector(cashappViewUpdate))
     return gesture
 }()
  
    var infoIsShowing = false
    weak var showAlertDelegate: DisplayDonationShowAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        cashappImageView.addGestureRecognizer(tapGesture)
        cashappImageView.isUserInteractionEnabled = true
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    
        showAlertDelegate?.didDisplayShowAlert(donateViewController: self)
    }
    
 
    @objc func cashappViewUpdate(sender:UITapGestureRecognizer){
        
        let directCashappUrlString = "https://cash.app/$TiffanyObi"
  
        
        if let url = URL(string:directCashappUrlString) {
            UIApplication.shared.open(url)
        }
    
      }

}
