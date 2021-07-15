//
//  XapotaskTests.swift
//  XapotaskTests
//
//  Created by Narek on 06.07.21.
//

import XCTest
import Combine
@testable import Xapotask

class XapotaskTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    private var urlSession: MockAPIProvider!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        urlSession = MockAPIProvider()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCacheResponses() throws {
        let cache: ICacheService = CacheService(1)
        let key1 = "test1"
        let key2 = "test2"
        
        cache.keepResponse(key: key1, response: Data())
        XCTAssert(cache.respone(for: key1) != nil)
        
        cache.keepResponse(key: key2, response: Data())
        XCTAssert(cache.respone(for: key1) == nil)
        
    }
    
    func testRepository() throws {
        
        let expectation = XCTestExpectation(description: "")
        
        urlSession.data = mockListJson.data(using: .utf8)!
        
        Repository(urlSession)
            .list()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }) { items in
                
                XCTAssert(items.count == 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDetailsViewModel() throws {
        let expectation = XCTestExpectation(description: "")
        var viewModel = DetailsViewModel("http://google.com")
        urlSession.data = mockDetailsJson.data(using: .utf8)!
        viewModel.urlSession = urlSession
        
        viewModel
            .fetch()
            .sink { repo in
                XCTAssert(repo?.url == "https://github.com/vsouza/awesome-ios")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
    }
}

struct MockAPIProvider: APIProvider {
    var data: Data!
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}


fileprivate let mockDetailsJson = """
        {
          "id": 21700699,
          "node_id": "MDEwOlJlcG9zaXRvcnkyMTcwMDY5OQ==",
          "name": "awesome-ios",
          "full_name": "vsouza/awesome-ios",
          "private": false,
          "html_url": "https://github.com/vsouza/awesome-ios",
          "description": "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects ",
          "fork": false,
          "url": "https://api.github.com/repos/vsouza/awesome-ios",
          "size": 15194,
          "stargazers_count": 37865,
          "watchers_count": 37865,
          "language": "Swift",
          "has_issues": true,
          "has_projects": false,
          "has_downloads": true,
          "has_wiki": false,
          "has_pages": false,
          "forks_count": 6308,
          "mirror_url": null,
          "archived": false,
          "disabled": false,
          "open_issues_count": 11,
          "license": {
            "key": "mit",
            "name": "MIT License",
            "spdx_id": "MIT",
            "url": "https://api.github.com/licenses/mit",
            "node_id": "MDc6TGljZW5zZTEz"
          },
          "updated_at": "2021-07-07T10:08:23Z",
          "forks": 6308,
          "open_issues": 11,
          "watchers": 37865,
          "default_branch": "master",
          "score": 1.0
        }
"""

fileprivate let mockListJson = """
    {
      "total_count": 870656,
      "incomplete_results": false,
      "items": [
""" + mockDetailsJson + """
]}
"""
