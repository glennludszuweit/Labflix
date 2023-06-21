//
//  HomeViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

@MainActor
class HomeViewController: UIViewController {
    let popularViewModel = PopularViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    let trendingViewModel = TrendingViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    let upcomingViewModel = UpcomingViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    let topRatedViewModel = TopRatedViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    
    var sections: [String:[Movie]] = ["Trending Movies": [], "Popular Movies": [], "Upcoming Movies": [], "Top Rated": []]
    
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
        
        trendingViewModel.getTrendingMovies(apiUrl: APIServices.trendingMovies)
        popularViewModel.getPopularMovies(apiUrl: APIServices.popularMovies)
        upcomingViewModel.getUpcomingMovies(apiUrl: APIServices.upcomingMovies)
        topRatedViewModel.getTopRatedMovies(apiUrl: APIServices.topRatedMovies)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
        
        DispatchQueue.main.async {
            self.sections = ["Trending Movies": self.trendingViewModel.trendingMovies, "Popular Movies": self.popularViewModel.popularMovies, "Upcoming Movies": self.upcomingViewModel.upcomingMovies, "Top Rated": self.topRatedViewModel.topRatedMovies]
        }
    }
}
