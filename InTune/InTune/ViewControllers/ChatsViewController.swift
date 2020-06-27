//
//  ChatsViewController.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 6/1/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listener: ListenerRegistration?
    
    private let databaseService = DatabaseService()
    
    var currentUserBucket: Artist!
    var otherUser: Artist?
    
    var users = [Artist]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var message: Message?
    
    var messages = [Message]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.artistsCollection).document((Auth.auth().currentUser?.uid)!).collection(DatabaseService.threadCollection).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                var artist = snapshot.documents.map { Artist($0.data()) }
                for (index, id) in artist.enumerated() {
                    if id.artistId == Auth.auth().currentUser?.uid {
                        artist.remove(at: index)
                    }
                }
                self.users = artist
                
            }
        })
    }
    
    deinit {
        listener?.remove()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .systemYellow
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ChatsCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        getCurrentArtist()
       
    }
    
    
//    private func getMessages(for artist: Artist) {
//
//        databaseService.fetchThread(sender: currentUserBucket, artist: artist) { (result) in
//
//            switch result {
//            case .failure(let error):
//                print("no msgs found: \(error.localizedDescription)")
//            case .success(let messages):
//                self.messages = messages
//            }
//        }
//    }
    
    private func getCurrentArtist() {
        guard let current = Auth.auth().currentUser else { return }
        databaseService.fetchArtist(userID: current.uid) { (result) in

            switch result {
            case .failure(let error):
                print("\(error.localizedDescription)")
            case .success(let artist):
                self.currentUserBucket = artist
            }
        }
    }
//
//    private func getOtherArtist(for artist: Artist) {
//        databaseService.fetchArtist(userID: artist.artistId) { (result) in
//
//            switch result {
//            case .failure(let error):
//                print("\(error.localizedDescription)")
//            case .success(let artist):
//                self.otherUser = artist
//            }
//        }
//
//    }
    
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatsCell else {
            fatalError("could not downcast to ChatsCell")
        }
        let contact = users[indexPath.row]
//        guard let message = message else { return }
//        let message = messages.last
        cell.configureCell(for: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        let user = users[indexPath.row]
        chatVC.artist = user
        chatVC.delegate = self
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension ChatsViewController: MessageThreadDelegate {
    func getLastMessage(_ vc: ChatViewController, _ messages: [Message]) {
        self.messages = messages
        print(messages)
    }
    
    
}
