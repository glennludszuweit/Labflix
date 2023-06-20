//
//  NetworkManager.swift
//  Combine-GettingStarted
//
//  Created by Glenn Ludszuweit on 05/05/2023.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func getAll<T: Decodable>(apiUrl: URL, type: T.Type) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkProtocol {
    func getAll<T>(apiUrl: URL, type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: apiUrl)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw APIError.networkError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.decodingError
                }
            }
            .eraseToAnyPublisher()
    }
}
