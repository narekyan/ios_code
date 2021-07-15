//
//  Repo.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import Foundation
import Combine

func listViewModel() -> AnyPublisher<[RepoListItem], Never> {
    let repository = Repository(URLSession.shared)
    return repository.list()
        .receive(on: DispatchQueue.main)
        .replaceError(with: [])
        .eraseToAnyPublisher()
}
