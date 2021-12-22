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
    private let userDefaults = makeStandardUserDefaults()
    
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
        selectedIndex = 1
        
        tabBar.tintColor = .systemTeal
    }
    
    private func makeLocationsPageViewController() -> LocationsPageViewController {
        let locationsPageViewController = LocationsPageViewController(client: client, userDefaults: userDefaults)
        
        locationsPageViewController.title = "Locations"
        locationsPageViewController.tabBarItem.image = UIImage(systemName: "globe.europe.africa.fill")
        
        return locationsPageViewController
    }
    
    private func makeOverviewViewController() -> UINavigationController {
        let overviewViewController = OverviewViewController(client: client, userDefaults: userDefaults)
        
        overviewViewController.title = "Overview"
        overviewViewController.tabBarItem.image = UIImage(systemName: "globe")
        
        return UINavigationController(rootViewController: overviewViewController)
    }
    
    private static func makeStandardUserDefaults() -> UserDefaults {
        let userDefaults = UserDefaults.standard
        
        userDefaults.register(defaults: [
            "suiteNames": ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
        ])
        
        return userDefaults
    }
    
}
