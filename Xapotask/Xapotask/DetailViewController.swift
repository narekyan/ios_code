//
//  ViewController.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    private var repo: RepoDetails!
    var viewModel: IDetailsViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetch()
            .sink { repo in
                guard let repo = repo else { return }
                
                self.repo = repo
                self.updateUI()
        }
        .store(in: &cancellables)
    }

    @IBAction func openWebsite() {
        UIApplication.shared.open(URL(string: repo.url)!, options: [:], completionHandler: nil)
    }

}

//MARK: private methods

extension DetailViewController {
    private func updateUI() {
        self.nameLabel.text = repo.name
        self.starsLabel.text = "⭐ \(self.repo.stars)"
        self.forksLabel.text = "🍴 \(repo.forks)"
        self.descriptionLabel.text = repo.description
        
    }
}
