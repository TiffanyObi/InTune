//
//  MainViewTabBarController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class MainViewTabBarController: UITabBarController {
    
    lazy var exploreVC:ExploreViewController = {
        let vc = ExploreViewController()
        vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 0)
        return vc
    }()
    
    lazy var likedArtistsVC:LikedArtistsViewController = {
        let vc = LikedArtistsViewController()
        vc.tabBarItem = UITabBarItem(title: "Liked Artists", image: UIImage(systemName: "bookmark.fill"), tag: 1)
        return vc
    }()
    
    lazy var gigsVC:GigViewController = {
        let vc = GigViewController()
        vc.tabBarItem = UITabBarItem(title: "Gigs", image: UIImage(systemName: "hand.thumbsup.fill"), tag: 2)
        return vc
    }()
    
    lazy var profileVC:ProfileViewController = {
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        guard let viewController =  storyboard.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return ProfileViewController()}
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 3)
        return viewController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadTopics()
        let controllers = [exploreVC,likedArtistsVC,gigsVC,profileVC]
        viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
    }
    
    
    
    
}
