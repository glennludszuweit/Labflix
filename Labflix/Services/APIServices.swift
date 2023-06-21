//
//  APIServices.swift
//  Combine-GettingStarted
//
//  Created by Glenn Ludszuweit on 05/05/2023.
//

import Foundation

class APIServices {
    static private let apiKey: String = "\(Bundle.main.infoDictionary?["TMDB-API"] ?? "")"
    static private let ratKey: String = "\(Bundle.main.infoDictionary?["TMDB-RAT"] ?? "")"
    
    static let tmdbBaseUrl: String = "https://api.themoviedb.org/3/"
    static let trendingMovies: String = "\(tmdbBaseUrl)trending/movie/week?api_key=\(apiKey)"
    static let popularMovies: String = "\(tmdbBaseUrl)movie/popular?api_key=\(apiKey)"
    static let upcomingMovies: String = "\(tmdbBaseUrl)movie/upcoming?api_key=\(apiKey)"
    static let topRatedMovies: String = "\(tmdbBaseUrl)movie/top_rated?api_key=\(apiKey)"
}
