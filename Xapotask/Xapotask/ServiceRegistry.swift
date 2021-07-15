//
//  CoordinatorManager.swift
//  fanFone
//
//  Created by Narek on 10/22/20.
//  Copyright © 2020 fanFone. All rights reserved.
//

import UIKit

struct ServiceRegistry {
    private static var serviceInitterDictionary : [String : () -> ILazyService] = [:]
    private static var serviceDictionary : [String : ILazyService] = [:]
    
    static func add(name: String, initter: @escaping () -> ILazyService) {
        ServiceRegistry.serviceInitterDictionary[name] = initter
    }
    
    static func serviceWith(name: String) -> ILazyService? {
        guard let service = ServiceRegistry.serviceDictionary[name] else {
            if let service = ServiceRegistry.serviceInitterDictionary[name]?() {
                ServiceRegistry.serviceDictionary[name] = service
                return service
            }
            return nil
        }
        return service
    }
}

protocol ILazyService {
    static var serviceName: String {get}
}
