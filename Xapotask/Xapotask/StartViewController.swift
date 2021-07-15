//
//  ViewController.swift
//  Xapotask
//
//  Created by Narek on 06.07.21.
//

import UIKit
import Combine

final class StartViewController: UIViewController {

    weak var coordinator: IStartCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
    }
    
    @IBAction func gotoXapo() {
        UIApplication.shared.open(URL(string: "https://www.xapo.com/")!, options: [:], completionHandler: nil)
    }

    @IBAction func openApp() {
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
