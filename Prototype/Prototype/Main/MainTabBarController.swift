//
//  MainTabBarController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 19/08/2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let overviewViewController = OverviewViewController()
    private let salahTimesViewController = SalahTimesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let overviewNavigationController = UINavigationController(rootViewController: overviewViewController)
        overviewViewController.title = "Overview"
        overviewViewController.tabBarItem.image = UIImage(systemName: "globe")
        
        let salahTimesNavigationController = UINavigationController(rootViewController: salahTimesViewController)
        salahTimesViewController.title = "Salah Times"
        salahTimesViewController.tabBarItem.image = UIImage(systemName: "calendar")
        
        viewControllers = [overviewNavigationController, salahTimesNavigationController]
    }
    
}
