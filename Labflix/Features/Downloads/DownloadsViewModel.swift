//
//  DownloadsViewModel.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 28/06/2023.
//

import Foundation
import Combine

class DownloadsViewModel {
    private let coreDataManager: CoreDataManager<MovieEntity>
    private var cancellables: Set<AnyCancellable> = []
    private var movies: [Movie] = [] {
        didSet {
            moviesSubject.send(movies)
        }
    }
    
    private let moviesSubject = CurrentValueSubject<[Movie], Never>([])
    
    var moviesPublisher: AnyPublisher<[Movie], Never> {
        moviesSubject.eraseToAnyPublisher()
    }
    
    init(coreDataManager: CoreDataManager<MovieEntity>) {
        self.coreDataManager = coreDataManager
    }
    
    func saveMovie(movie: Movie) {
        
        let movieEntity = MovieEntity(context: coreDataManager.context)
        movieEntity.id = Int64(movie.id ?? 0)
        movieEntity.title = movie.title
        movieEntity.originalTitle = movie.originalTitle
        movieEntity.originalLanguage = movie.originalLanguage
        movieEntity.overview = movie.overview
        movieEntity.popularity = movie.popularity ?? 0
        movieEntity.posterPath = movie.posterPath
        movieEntity.releaseDate = movie.releaseDate
        movieEntity.voteAverage = movie.voteAverage ?? 0
        movieEntity.voteCount = Int64(movie.voteCount ?? 0)
        
        coreDataManager.saveData(data: [movieEntity])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Movie saved successfully.")
                case .failure(let error):
                    print("Failed to save movie: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func fetchMovies() {
        coreDataManager.fetchData()
            .map { entities in
                entities.compactMap { entity -> Movie? in
                    return Movie(
                        id: Int(entity.id),
                        originalLanguage: entity.originalLanguage, originalTitle: entity.originalTitle, overview: entity.overview, popularity: entity.popularity, posterPath: entity.posterPath, releaseDate: entity.releaseDate, title: entity.title, video: entity.video, voteAverage: entity.voteAverage, voteCount: Int(entity.voteCount))
                }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch movies: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
}






