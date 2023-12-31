//
//  HeroHeaderView.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 20/06/2023.
//

import UIKit

class HeroHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "flash")
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyActionButtonConstraints() {
        let titleLabelConstraints = [
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let playButtonConstrains = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        let downloadButtonConstrains = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstrains)
        NSLayoutConstraint.activate(downloadButtonConstrains)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        
        addSubview(playButton)
        addSubview(titleLabel)
        addSubview(downloadButton)
        applyActionButtonConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureHeroImageView(with movie: Movie) {
        guard let imageUrl = URL(string: "\(APIServices.imageBaseUrl500)\(movie.posterPath ?? "")") else { return }
        titleLabel.text = movie.title
        heroImageView.sd_setImage(with: imageUrl)
    }
}
