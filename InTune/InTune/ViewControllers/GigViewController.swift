//
//  GigViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GigViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listener: ListenerRegistration?
    
    var gigs = [GigsPost]() {
        didSet {
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GigCell", bundle: nil), forCellReuseIdentifier: "gigCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
          

          
    
    }
    



}

extension GigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath) as? GigCell else {
            fatalError("could not get cell")
        }
//        let gig = gigs[indexPath.row]
        
        return cell
    }
}

extension GigViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = GigsDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
