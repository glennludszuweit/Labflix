//
//  CollectionViewTableViewCell.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 20/06/2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewDidSelectCell(_ cell: CollectionViewTableViewCell, model: Preview)
}

class CollectionViewTableViewCell: UITableViewCell {
    let homeViewModel = HomeViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    let movieViewModel = MovieViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    static let identifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    private var movies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func setMovies(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setPosterImage(with: movies[indexPath.row].posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        var youtubeVideo: YoutubeVideo?
        guard let title = movie.title else { return }
        guard let overview = movie.overview else { return }
        
        movieViewModel.getMovie(apiUrl: "\(APIServices.youtubeSearch)", query: "\(title) trailer")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    guard let youtubeVideo = youtubeVideo else { return }
                    guard let strongSelf = self else { return }
                    let preview = Preview(title: title, overview: overview, youtube: youtubeVideo)
                    self?.delegate?.collectionViewTableViewDidSelectCell(strongSelf, model: preview)
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { youtube in
                youtubeVideo = youtube
            }
            .store(in: &homeViewModel.cancellable)
    }
}
