//
//  APIServices.swift
//  Combine-GettingStarted
//
//  Created by Glenn Ludszuweit on 05/05/2023.
//

import Foundation

class APIServices {
    static private let tmdbApiKey: String = "\(Bundle.main.infoDictionary?["TMDB-API"] ?? "")"
    static private let youtubeApiKey: String = "\(Bundle.main.infoDictionary?["YOUTUBE-API"] ?? "")"
    
    static let tmdbBaseUrl: String = "https://api.themoviedb.org/3/"
    static let imageBaseUrl500: String = "https://image.tmdb.org/t/p/w500"
    static let trendingMovies: String = "\(tmdbBaseUrl)trending/movie/week?api_key=\(tmdbApiKey)"
    static let popularMovies: String = "\(tmdbBaseUrl)movie/popular?api_key=\(tmdbApiKey)"
    static let upcomingMovies: String = "\(tmdbBaseUrl)movie/upcoming?api_key=\(tmdbApiKey)"
    static let topRatedMovies: String = "\(tmdbBaseUrl)movie/top_rated?api_key=\(tmdbApiKey)"
    static let discoverMovies: String = "\(tmdbBaseUrl)discover/movie?api_key=\(tmdbApiKey)"
    static let searchMovies: String = "\(tmdbBaseUrl)search/movie?api_key=\(tmdbApiKey)&query="
    
    static let youtubeSearch: String = "https://youtube.googleapis.com/youtube/v3/search?key=\(youtubeApiKey)&q="
}
