//
//  MainController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 16/06/2023.
//

import UIKit

class MainController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.title = "Home"
        
        let comingVC = UINavigationController(rootViewController: ComingViewController())
        comingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        comingVC.title = "Coming Up"
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.title = "Search"
        
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloadsVC.title = "Downloads"
        
        tabBar.tintColor = .label
        setViewControllers([homeVC, comingVC, searchVC, downloadsVC], animated: true)
    }
}

