//
//  ViewController.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var starsLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var repo: RepoDetails!
    var viewModel: IDetailsViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .fetch()
            .sink { repo in
                guard let repo = repo else { return }
                
                self.repo = repo
                self.updateUI()
                
            }
            .store(in: &cancellables)
        
        view.addSubview(nameLabel)
        view.addSubview(starsLabel)
        
        configureConstraints()
    }
    
    // I could use snapkit
    private func configureConstraints() {
        NSLayoutConstraint.activate([

            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            starsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            starsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            
        ])
    }
}

//MARK: private methods

extension DetailViewController {
    private func updateUI() {
        self.nameLabel.text = repo.name
        self.starsLabel.text = "⭐ \(self.repo.stars)"
    }
}
