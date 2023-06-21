//
//  PopularViewModel.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 21/06/2023.
//

import Foundation
import Combine

class PopularViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var errorMessage: String = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    var networkManager: NetworkProtocol
    var errorManager: ErrorProtocol
    
    init(networkManager: NetworkProtocol, errorManager: ErrorProtocol) {
        self.networkManager = networkManager
        self.errorManager = errorManager
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
                    print("Popular movies array populated.")
                    // completion code
                case .failure(let error):
                    self.errorMessage = self.errorManager.handleError(error)
                }
            } receiveValue: { data in
                self.popularMovies = data.results
            }
            .store(in: &cancellable)
    }
}
