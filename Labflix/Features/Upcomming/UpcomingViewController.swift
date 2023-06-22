//
//  UpcomingViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    let upcomingViewModel = UpcomingViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    var movies: [Movie] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private func getUpcomingMovies() {
        upcomingViewModel.getUpcomingMovies(apiUrl: APIServices.upcomingMovies)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.upcomingTable.reloadData()
                    }
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &upcomingViewModel.cancellable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        
        getUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
}
