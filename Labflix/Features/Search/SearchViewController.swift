//
//  DiscoverViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchViewModel = SearchViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    private let movieViewModel = MovieViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    private var movies: [Movie] = []
    private var searchTerm: String = ""
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search movie ..."
        search.searchBar.searchBarStyle = .default
        search.obscuresBackgroundDuringPresentation = false
        return search
    }()
    
    private func searchMovies() {
        searchViewModel.getSearchedMovies(apiUrl: APIServices.searchMovies, query: searchTerm)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.searchTable.reloadData()
                    }
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &searchViewModel.cancellable)
    }
    
    private func getDiscoverMovies() {
        searchViewModel.getDiscoverMovies(apiUrl: APIServices.discoverMovies)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.searchTable.reloadData()
                    }
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &searchViewModel.cancellable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        
        view.addSubview(searchTable)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchTable.dataSource = self
        searchTable.delegate = self
        getDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
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
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            self.searchTerm = text
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !self.searchTerm.trimmingCharacters(in: .whitespaces).isEmpty && self.searchTerm.trimmingCharacters(in: .whitespaces).count > 0 {
            searchMovies()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getDiscoverMovies()
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
