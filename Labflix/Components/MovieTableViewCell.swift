//
//  MovieTableViewCell.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 22/06/2023.
//

import UIKit
import SDWebImage
import Combine

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
//    private var downloadsViewModel: DownloadsViewModel!
//    private var cancellables: Set<AnyCancellable> = []
//    private var movie: Movie!
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
//    private let downloadButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "arrow.down.to.line", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
//        button.setImage(image, for: .normal)
//        button.tintColor = .label
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private func applyConstraints() {
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImageView.widthAnchor.constraint(equalToConstant: 75)
        ]
        let movieLabelConstraints = [
            movieLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieLabel.widthAnchor.constraint(equalToConstant: 200),
        ]
//        let playButtonConstraints = [
//            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            downloadButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(movieLabelConstraints)
//        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieLabel)
//        contentView.addSubview(downloadButton)
//        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        applyConstraints()
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            fatalError("AppDelegate not found")
//        }
//        let context = appDelegate.persistentContainer.viewContext
//        let coreDataManager = CoreDataManager<MovieEntity>(context: context)
//        downloadsViewModel = DownloadsViewModel(coreDataManager: coreDataManager)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func setCellData(with movie: Movie) {
        guard let imageUrl = URL(string: "\(APIServices.imageBaseUrl500)\(movie.posterPath ?? "")") else { return }
        movieLabel.text = movie.originalTitle
        posterImageView.sd_setImage(with: imageUrl)
//        self.movie = movie
    }
    
//    @objc func downloadButtonTapped() {
//        print("test")
//        downloadsViewModel.saveMovie(movie: self.movie)
//    }
}
