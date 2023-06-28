//
//  DownloadsViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit
import CoreData
import Combine

class DownloadsViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private let downloadsViewModel: DownloadsViewModel = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let context = appDelegate.persistentContainer.viewContext
        let coreDataManager = CoreDataManager<MovieEntity>(context: context)
        return DownloadsViewModel(coreDataManager: coreDataManager)
    }()
    
    private var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.upcomingTable.reloadData()
            }
        }
    }
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private func setupViewModel() {
        downloadsViewModel.fetchMovies()
        downloadsViewModel.moviesPublisher
            .sink { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        
        setupViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.setCellData(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        var youtubeVideo: YoutubeVideo?
        guard let title = movie.title else { return }
        guard let overview = movie.overview else { return }
        guard let youtubeVideo = youtubeVideo else { return }
        
        // Your existing code for getting the Youtube video
        
        let preview = Preview(title: title, overview: overview, youtube: youtubeVideo)
        let movieViewController = MovieViewController()
        movieViewController.setMovie(with: preview)
        movieViewController.getMovie(with: movie)
        navigationController?.pushViewController(movieViewController, animated: true)
    }
}
