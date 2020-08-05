//
//  ShowContributorsViewController.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 8/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ShowContributorsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: DataSource!
    private var database = DatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        loadContributors()
        tableView.delegate = self
        
    }
    
    private func configureDataSource(){
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, contributor) -> UITableViewCell? in
            let contributorCell = tableView.dequeueReusableCell(withIdentifier: "contributorCell", for: indexPath)
            
            contributorCell.textLabel?.text = contributor.name
            contributorCell.textLabel?.font = UIFont(name: "Didot", size: 25.0)
            contributorCell.detailTextLabel?.text = "Donation: $ \(contributor.amountDonated ?? 0.00)"
            contributorCell.detailTextLabel?.font = UIFont(name: "Didot", size: 18.0)
            return contributorCell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Contributor>()
        snapshot.appendSections([.allContributors])
        dataSource.apply(snapshot)
    }
    
    private func loadContributors(){
        database.fetchContribution { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Loading...", message:error.localizedDescription)
                
            case .success(let contributors):
                self?.updateSnapshot(with: contributors)
            }
        }
    }
    
    private func updateSnapshot(with contributors:[Contributor]){
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(contributors, toSection: .allContributors)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    

}

extension ShowContributorsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
