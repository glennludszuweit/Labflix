//
//  ErrorManager.swift
//  Combine-GettingStarted
//
//  Created by Glenn Ludszuweit on 05/05/2023.
//

import Foundation

protocol ErrorProtocol {
    func handleError(_ error: Error) -> String
}

enum APIError: Error {
    case invalidURL
    case networkError
    case decodingError
}

class ErrorManager: ErrorProtocol {
    func handleError(_ error: Error) -> String {
        switch error {
        case APIError.invalidURL:
            return NSLocalizedString("Invalid URL", comment: "invalidURL")
        case APIError.networkError:
            return NSLocalizedString("Network Error", comment: "networkError")
        case APIError.decodingError:
            return NSLocalizedString("Decoding Error", comment: "decodingError")
        default:
            return NSLocalizedString("Unknown Error", comment: "unknownError")
        }
    }
}
