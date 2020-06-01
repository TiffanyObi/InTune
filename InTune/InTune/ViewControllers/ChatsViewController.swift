//
//  ChatsViewController.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 6/1/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [Contacts]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var user1 = Contacts(name: "Tiffany", id: "123456789")
    
    var user2 = Contacts(name: "Alex", id: "987654321")
    
    var user3 = Contacts(name: "Mai", id: "1010101010101")
    
    var user4 = Contacts(name: "Christian", id: "777777777")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        tableView.dataSource = self
        tableView.delegate = self
        loadUsers()
    }
    
    private func loadUsers() {
        users.append(user1)
        users.append(user2)
        users.append(user3)
        users.append(user4)
    }
    
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        let contact = users[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        let userName = users[indexPath.row]
        chatVC.user2Name = userName.name
        chatVC.user2UID = userName.id
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
