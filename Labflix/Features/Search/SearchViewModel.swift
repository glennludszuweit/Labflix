//
//  SearchViewModel.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 23/06/2023.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    var errorMessage: String = ""
    var cancellable = Set<AnyCancellable>()
    var networkManager: NetworkProtocol
    var errorManager: ErrorProtocol
    
    init(networkManager: NetworkProtocol, errorManager: ErrorProtocol) {
        self.networkManager = networkManager
        self.errorManager = errorManager
    }
    
    func getDiscoverMovies(apiUrl: String) -> AnyPublisher<[Movie], Error> {
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
    
    func getSearchedMovies(apiUrl: String) -> AnyPublisher<[Movie], Error> {
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
