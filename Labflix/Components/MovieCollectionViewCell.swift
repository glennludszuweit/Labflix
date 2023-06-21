//
//  MovieCollectionViewCell.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 21/06/2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func setPosterImage(with imageUrl: String) {
        guard let url = URL(string: "\(APIServices.imageBaseUrl500)\(imageUrl)") else { return }
        posterImageView.sd_setImage(with: url)
    }
}
