//
//  MovieViewModel.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 25/06/2023.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    var errorMessage: String = ""
    var cancellable = Set<AnyCancellable>()
    var networkManager: NetworkProtocol
    var errorManager: ErrorProtocol
    
    init(networkManager: NetworkProtocol, errorManager: ErrorProtocol) {
        self.networkManager = networkManager
        self.errorManager = errorManager
    }
    
    func getMovie(apiUrl: String, query: String) -> AnyPublisher<YoutubeVideo, Error> {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: "\(apiUrl)\(query)") else {
            self.errorMessage = errorManager.handleError(APIError.invalidURL)
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return self.networkManager.get(apiUrl: url, type: Youtube.self)
            .map { $0.items[0] }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = self?.errorManager.handleError(error) ?? ""
                }
            })
            .eraseToAnyPublisher()
    }
}
