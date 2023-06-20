//
//  HomeViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

class HomeViewController: UIViewController {
    let sectionTitles: [String] = ["Trending Movies", "Trending TV Shows", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private func configureNavBar() {
        var logo = UIImage(named: "logo")
        logo = logo?.resized(to: CGSize(width: 48, height: 48))
        logo = logo?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))

        view.backgroundColor = .systemBackground
        view.addSubview(homeTable)
        
        configureNavBar()
        
        homeTable.dataSource = self
        homeTable.delegate = self
        homeTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
    }
}
