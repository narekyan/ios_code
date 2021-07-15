//
//  Repo.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import Foundation
import Combine

protocol APIProvider {
    typealias APIResponse = URLSession.DataTaskPublisher.Output
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError>
}

extension URLSession: APIProvider {
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

protocol IRepository {
    associatedtype T
    associatedtype U
    
    func get(_ url: String) -> AnyPublisher<U?, Error>
    func list() -> AnyPublisher<[T], Error>
}

class Repository: IRepository {
    typealias T = RepoListItem
    typealias U = RepoDetails
    
    private var cacheService: ICacheService = {
       return ServiceRegistry.serviceWith(name: CacheService.serviceName) as! ICacheService
    }()
    
    private var urlSession: APIProvider!
    
    
    init(_ urlSession: APIProvider) {
        self.urlSession = urlSession
    }
    
    func get(_ url: String) -> AnyPublisher<U?, Error> {

        if let repo = cacheService.respone(for: url) as? GithubRepo {
            let details = U.init(name: repo.name, stars: repo.size, forks: repo.forks, description: repo.description, url: repo.html_url)
            return CurrentValueSubject<U?, Error>(details).eraseToAnyPublisher()
        }
        
        return urlSession
            .apiResponse(for: URLRequest(url: URL(string: url)!))
            .tryMap { result -> Data in
                guard let r = result.response as? HTTPURLResponse, r.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: GithubRepo.self, decoder: JSONDecoder())
            .map({
                self.cacheService.keepResponse(key: $0.url, response: $0)
                let repo = U.init(name: $0.name, stars: $0.size, forks: $0.forks, description: $0.description, url: $0.html_url)
                return repo
            })
            .eraseToAnyPublisher()
    }
    
    func list() -> AnyPublisher<[T], Error> {
        
        struct Response: Codable {
            var items: [GithubRepo]
        }
        
        // url to trending repositories
        let url = URL(string: "https://api.github.com/search/repositories?q=language:Swift&sort=stars")!
        return urlSession
            .apiResponse(for: URLRequest(url: url))
            .tryMap { result -> Data in
                guard let r = result.response as? HTTPURLResponse, r.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map({ $0.items })
            .map({ $0.map({
                self.cacheService.keepResponse(key: $0.url, response: $0)
                return T.init(url: $0.url, name: $0.name, stars: $0.size)
                })
            })
            .eraseToAnyPublisher()
    }
    
}
