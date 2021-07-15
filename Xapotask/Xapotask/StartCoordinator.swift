//
//  CoordinatorManager.swift
//  fanFone
//
//  Created by Narek on 10/22/20.
//  Copyright © 2020 fanFone. All rights reserved.
//

import UIKit

protocol IStartCoordinator: AnyObject {

    func showList()
    func showDetails(_ repoUrl: String)
}

class StartCoordinator {
 
    private var navigationController: UINavigationController?
    
    init() {
        ServiceRegistry.add(name: CacheService.serviceName, initter: {
            return CacheService()
        })
    }
    
    func start(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        start()
    }       
}

extension StartCoordinator {
    private func start() {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: StartViewController.self)) as! StartViewController
        vc.coordinator = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func startList() {
        let vc = ListViewController()
        vc.coordinator = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func startDetails(_ repoUrl: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
        vc.viewModel = DetailsViewModel(repoUrl)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StartCoordinator: IStartCoordinator {
    func showList() {
        startList()
    }
    
    func showDetails(_ repoUrl: String) {
        startDetails(repoUrl)
    }
}
