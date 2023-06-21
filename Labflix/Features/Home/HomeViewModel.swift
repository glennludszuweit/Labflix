//
//  HomeViewModel.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 21/06/2023.
//

import Foundation
import Combine

enum Sections: Int {
    case trending = 0
    case popular = 1
    case upcoming = 2
    case topRated = 3
}

class HomeViewModel: ObservableObject {
    @Published var sectionsTitle: [String] = ["Trending Movies", "Popular Movies", "Upcoming Movies", "Top Rated"]
    @Published var movies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var errorMessage: String = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    var networkManager: NetworkProtocol
    var errorManager: ErrorProtocol
    
    init(networkManager: NetworkProtocol, errorManager: ErrorProtocol) {
        self.networkManager = networkManager
        self.errorManager = errorManager
    }
    
    func getTrendingMovies(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = errorManager.handleError(APIError.invalidURL)
            return
        }
        
        self.networkManager.get(apiUrl: url, type: Movies.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.movies = self.trendingMovies
                case .failure(let error):
                    self.errorMessage = self.errorManager.handleError(error)
                }
            } receiveValue: { data in
                self.trendingMovies = data.results
            }
            .store(in: &cancellable)
    }
    
    func getPopularMovies(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = errorManager.handleError(APIError.invalidURL)
            return
        }
        
        self.networkManager.get(apiUrl: url, type: Movies.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.movies = self.popularMovies
                case .failure(let error):
                    self.errorMessage = self.errorManager.handleError(error)
                }
            } receiveValue: { data in
                self.popularMovies = data.results
            }
            .store(in: &cancellable)
    }
    
    func getUpcomingMovies(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = errorManager.handleError(APIError.invalidURL)
            return
        }
        
        self.networkManager.get(apiUrl: url, type: Movies.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.movies = self.upcomingMovies
                case .failure(let error):
                    self.errorMessage = self.errorManager.handleError(error)
                }
            } receiveValue: { data in
                self.upcomingMovies = data.results
            }
            .store(in: &cancellable)
    }
    
    func getTopRatedMovies(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = errorManager.handleError(APIError.invalidURL)
            return
        }
        
        self.networkManager.get(apiUrl: url, type: Movies.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.movies = self.topRatedMovies
                case .failure(let error):
                    self.errorMessage = self.errorManager.handleError(error)
                }
            } receiveValue: { data in
                self.topRatedMovies = data.results
            }
            .store(in: &cancellable)
    }
}
