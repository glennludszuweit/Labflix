//
//  DiscoverViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchViewModel = SearchViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    private var movies: [Movie] = []
    private var searchTerm: String = ""
    
    private let discoverTable: UITableView = {
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
        searchViewModel.getDiscoverMovies(apiUrl: "\(APIServices.searchMovies)\(searchTerm)")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.discoverTable.reloadData()
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
                        self?.discoverTable.reloadData()
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
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(discoverTable)
        discoverTable.dataSource = self
        discoverTable.delegate = self
        getDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            self.searchTerm = text
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // Perform the submit button action here
        searchMovies()
        }
    
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
