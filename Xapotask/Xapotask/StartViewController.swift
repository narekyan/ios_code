//
//  ViewController.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import UIKit
import Combine

final class StartViewController: UIViewController {

    
    private lazy var start: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Start", for: .normal)
        view.addTarget(self, action: #selector(openApp), for: .touchUpInside)
        return view
    }()
    
    weak var coordinator: IStartCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        view.addSubview(start)
        NSLayoutConstraint.activate([

            start.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            start.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            start.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
        ])
    }

    @objc
    private func openApp() {
        coordinator?.showList()
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
