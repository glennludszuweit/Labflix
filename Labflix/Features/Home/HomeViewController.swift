//
//  HomeViewController.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 19/06/2023.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeViewModel = HomeViewModel(networkManager: NetworkManager(), errorManager: ErrorManager())
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private func configureNavBar() {
        var logo = UIImage(named: "logo")
        logo = logo?.resized(to: CGSize(width: 48, height: 48))
        logo = logo?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))

        view.backgroundColor = .systemBackground
        view.addSubview(homeTable)
        
        configureNavBar()
        
        homeTable.dataSource = self
        homeTable.delegate = self
        homeTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
        DispatchQueue.main.async { [weak self] in
            self?.homeTable.reloadData()
        }
    }
}

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
            homeViewModel.getMovies(apiUrl: APIServices.trendingMovies)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Tending movies populated.")
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                } receiveValue: { movies in
                    cell.setMovies(with: movies)
                }
                .store(in: &homeViewModel.cancellable)
            
        case Sections.popular.rawValue:
            homeViewModel.getMovies(apiUrl: APIServices.popularMovies)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Popular movies populated.")
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                } receiveValue: { movies in
                    cell.setMovies(with: movies)
                }
                .store(in: &homeViewModel.cancellable)
        case Sections.upcoming.rawValue:
            homeViewModel.getMovies(apiUrl: APIServices.upcomingMovies)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Upcoming movies populated.")
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                } receiveValue: { movies in
                    cell.setMovies(with: movies)
                }
                .store(in: &homeViewModel.cancellable)
        case Sections.topRated.rawValue:
            homeViewModel.getMovies(apiUrl: APIServices.topRatedMovies)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Top rated movies populated.")
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                } receiveValue: { movies in
                    cell.setMovies(with: movies)
                }
                .store(in: &homeViewModel.cancellable)
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
