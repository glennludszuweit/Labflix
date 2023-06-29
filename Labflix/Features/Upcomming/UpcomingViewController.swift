//
//  UpcomingViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    private let upcomingViewModel = UpcomingViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    private let movieViewModel = MovieViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    private var movies: [Movie] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private func getUpcomingMovies(page: Int = 1) {
        upcomingViewModel.getUpcomingMovies(apiUrl: "\(APIServices.upcomingMovies)&page=\(page)")
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

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.setCellData(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        var youtubeVideo: YoutubeVideo?
        guard let title = movie.title else { return }
        guard let overview = movie.overview else { return }
        
        movieViewModel.getMovie(apiUrl: "\(APIServices.youtubeSearch)", query: "\(title) trailer")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    guard let youtubeVideo = youtubeVideo else { return }
                    let preview = Preview(title: title, overview: overview, youtube: youtubeVideo)
                    let movieViewController = MovieViewController()
                    movieViewController.setMovie(with: preview)
                    movieViewController.getMovie(with: movie)
                    self?.navigationController?.pushViewController(movieViewController, animated: true)
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { youtube in
                youtubeVideo = youtube
            }
            .store(in: &movieViewModel.cancellable)
    }
}
