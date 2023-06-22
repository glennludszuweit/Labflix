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
    let sectionsTitle: [String] = ["Trending Movies", "Popular Movies", "Upcoming Movies", "Top Rated"]
    var errorMessage: String = ""
    var cancellable = Set<AnyCancellable>()
    var networkManager: NetworkProtocol
    var errorManager: ErrorProtocol
    
    init(networkManager: NetworkProtocol, errorManager: ErrorProtocol) {
        self.networkManager = networkManager
        self.errorManager = errorManager
    }
    
    func getMovies(apiUrl: String) -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = errorManager.handleError(APIError.invalidURL)
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return self.networkManager.get(apiUrl: url, type: Movies.self)
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = self?.errorManager.handleError(error) ?? ""
                }
            })
            .eraseToAnyPublisher()
    }
}
