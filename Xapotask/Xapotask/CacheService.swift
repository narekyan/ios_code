//
//  NetworkFeature.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation
import Combine

protocol ICacheService {
    func keepResponse(key: String, response: Decodable)
    func respone(for key: String) -> Decodable?
}

class CacheService: ICacheService, ILazyService {
    static var serviceName: String {
        return "CacheService"
    }
        
    private var cache = [String: Decodable]()
    private var keys = [String]()
    private var maxCount: Int!
    
    init(_ maxCount: Int = 10) {
        self.maxCount = maxCount
    }
    
    func keepResponse(key: String, response: Decodable) {
        if keys.count == maxCount {
            let key = keys.removeFirst()
            cache.removeValue(forKey: key)
        }
        keys.append(key)
        cache[key] = response
    }
    
    func respone(for key: String) -> Decodable? {
        cache[key]
    }
}
