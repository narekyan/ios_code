//
//  GithubRepo.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import Foundation

struct GithubRepo: Codable {
    var id: Int
    var name: String
    var html_url: String
    var description: String?
    var updated_at: String
    var size: Int
    var forks: Int
    var url: String
}
