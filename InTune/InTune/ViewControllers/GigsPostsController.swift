//
//  GigsPostsController.swift
//  InTune
//
//  Created by Tiffany Obi on 6/24/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class GigsPostsController: UIViewController {
    
    @IBOutlet weak var gigsTableView: UITableView!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    private var gigs = [FavGig](){
        didSet{
            gigsTableView.reloadData()
        }
    }
    
    var gigListener: ListenerRegistration?
    var postsListener: ListenerRegistration?
    
    private var posts = [GigsPost](){
        didSet{
            postsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViews()
        gigsTableView.register(UINib(nibName: "GigCell", bundle: nil), forCellReuseIdentifier: "gigCell")
        postsTableView.register(UINib(nibName: "GigCell", bundle: nil), forCellReuseIdentifier: "gigCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let user = Auth.auth().currentUser else {return}
        
        postsListener = Firestore.firestore().collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.gigPosts).addSnapshotListener({ [weak self](snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Firestore Error", message: error.localizedDescription)
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { GigsPost($0.data())
                }
                self?.posts = posts
                
            }
        })
        
        
        gigListener = Firestore.firestore().collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.favGigPosts).addSnapshotListener({ [weak self](snapshot, error) in
            if let error = error{
                DispatchQueue.main.async {
                    
                self?.showAlert(title: "FireStore Error", message: error.localizedDescription)
                }
            } else if let snapshot = snapshot {
                let gigs = snapshot.documents.map { FavGig($0.data())
                }
                self?.gigs = gigs
            }
        })
    }
    func setUpTableViews(){
        gigsTableView.dataSource = self
        gigsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.delegate = self
    }
    
    
    
}
extension GigsPostsController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == gigsTableView {
            return gigs.count
        }
        
        if tableView == postsTableView {
            return posts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == gigsTableView {
            guard let gigCell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath) as? GigCell else {
                fatalError("Could not downcast GigCell")
            }
            let gig = gigs[indexPath.row]
            gigCell.configureFavGig(for: gig)
          
            return gigCell
        }
        
        if tableView == postsTableView {
            guard let gigCell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath) as? GigCell else {
                fatalError("Could not downcast GigCell")
            }
            let post = posts[indexPath.row]
            
            gigCell.configureGig(for: post)
          
            return gigCell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
