//
//  ViewController.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import UIKit
import Combine

final class ListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var areConstraintsSet = false
    private var cancellables = Set<AnyCancellable>()
    private var trendingRepos = [RepoListItem]()
    
    weak var coordinator: IStartCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        let trendingRepos = listViewModel()
        trendingRepos.sink { list in
            self.trendingRepos = list
            self.tableView.reloadData()
        }
        .store(in: &cancellables)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !areConstraintsSet {
            areConstraintsSet = true

            NSLayoutConstraint.activate([

                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                
            ])
        }
    }
}

//MARK: - Table Delegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trendingRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = trendingRepos[indexPath.row].name
        cell?.detailTextLabel?.text = "⭐ \(trendingRepos[indexPath.row].stars)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.showDetails(trendingRepos[indexPath.row].url)
    }
}
