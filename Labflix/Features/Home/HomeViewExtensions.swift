//
//  Extensions.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 20/06/2023.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeViewModel.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        switch indexPath.section {
        case Sections.trending.rawValue:
            homeViewModel.getTrendingMovies(apiUrl: APIServices.trendingMovies)
            DispatchQueue.main.async { [weak self] in
                guard let movies = self?.homeViewModel.trendingMovies else { return }
                cell.setMovies(with: movies)
            }
        case Sections.popular.rawValue:
            homeViewModel.getPopularMovies(apiUrl: APIServices.popularMovies)
            DispatchQueue.main.async { [weak self] in
                guard let movies = self?.homeViewModel.popularMovies else { return }
                cell.setMovies(with: movies)
            }
        case Sections.upcoming.rawValue:
            homeViewModel.getUpcomingMovies(apiUrl: APIServices.upcomingMovies)
            DispatchQueue.main.async { [weak self] in
                guard let movies = self?.homeViewModel.upcomingMovies else { return }
                cell.setMovies(with: movies)
            }
        case Sections.topRated.rawValue:
            homeViewModel.getTopRatedMovies(apiUrl: APIServices.topRatedMovies)
            DispatchQueue.main.async { [weak self] in
                guard let movies = self?.homeViewModel.topRatedMovies else { return }
                cell.setMovies(with: movies)
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeViewModel.sectionsTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalized(with: .current)
        header.textLabel?.frame = CGRect(x: Int(header.bounds.origin.x) + 20, y: 0, width: 100, height: Int(header.bounds.height))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
