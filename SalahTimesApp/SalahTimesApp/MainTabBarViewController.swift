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
    
    private let salahTimesLoader: TimesLoader
    private let userDefaults = makeStandardUserDefaults()
    
    init(salahTimesLoader: TimesLoader) {
        self.salahTimesLoader = salahTimesLoader
        
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
        let locationsPageViewController = LocationsPageViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults)
        
        locationsPageViewController.title = "Locations"
        locationsPageViewController.tabBarItem.image = UIImage(systemName: "calendar")
        
        return locationsPageViewController
    }
    
    private func makeOverviewViewController() -> UINavigationController {
        let overviewViewController = OverviewViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults)
        
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
