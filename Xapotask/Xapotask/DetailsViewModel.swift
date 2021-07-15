//
//  Repo.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import Foundation
import Combine

protocol IDetailsViewModel {
    func fetch() -> AnyPublisher<RepoDetails?, Never>
}

struct DetailsViewModel: IDetailsViewModel {
    
    private var repoUrl: String!
    var urlSession: APIProvider!
    
    init(_ repoUrl: String, urlSession: URLSession = .shared) {
        self.repoUrl = repoUrl
        self.urlSession = urlSession
    }
    
    func fetch() -> AnyPublisher<RepoDetails?, Never> {
        let repository = Repository(urlSession)
        return repository.get(repoUrl)
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .eraseToAnyPublisher()

    }
}
