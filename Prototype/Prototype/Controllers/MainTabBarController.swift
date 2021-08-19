//
//  MainTabBarController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 19/08/2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let salahTimesViewController = SalahTimesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        let salahTimesNavigationController = UINavigationController(rootViewController: salahTimesViewController)
        
        salahTimesViewController.title = "Salah Times"
        salahTimesViewController.tabBarItem.image = UIImage(systemName: "calendar")
        
        viewControllers = [salahTimesNavigationController]
    }
    
}
