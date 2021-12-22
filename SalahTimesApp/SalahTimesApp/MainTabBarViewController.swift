//
//  MainTabBarViewController.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 16/12/2021.
//

import UIKit
import SalahTimes
import SalahTimesiOS

final class MainTabBarViewController: UITabBarController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [makeOverviewViewController(), makeLocationsPageViewController()]
        
        tabBar.tintColor = .systemTeal
    }
    
    private func makeLocationsPageViewController() -> LocationsPageViewController {
        let locationsPageViewController = LocationsPageViewController(client: client, userDefaults: getUserDefaults())
        
        locationsPageViewController.title = "Locations"
        locationsPageViewController.tabBarItem.image = UIImage(systemName: "globe.europe.africa.fill")
        
        return locationsPageViewController
    }
    
    private func makeOverviewViewController() -> UINavigationController {
        let overviewViewController = OverviewViewController()
        
        overviewViewController.title = "Overview"
        overviewViewController.tabBarItem.image = UIImage(systemName: "globe")
        
        return UINavigationController(rootViewController: overviewViewController)
    }
    
    private func getUserDefaults() -> UserDefaults {
        let userDefaults = UserDefaults.standard
        
        userDefaults.register(defaults: [
            "suiteNames": ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
        ])
        
        return userDefaults
    }
    
}
