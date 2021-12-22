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
        viewControllers = [makeLocationsPageViewController()]
        
        tabBar.tintColor = .systemTeal
    }
    
    private func makeLocationsPageViewController() -> LocationsPageViewController {
        let locationsPageViewController = LocationsPageViewController(userDefaults: getUserDefaults())
        
        locationsPageViewController.title = "Locations"
        locationsPageViewController.tabBarItem.image = UIImage(systemName: "globe")
        
        return locationsPageViewController
    }
    
    private func getUserDefaults() -> UserDefaults {
        let userDefaults = UserDefaults.standard
        
        let locationsSuiteNames: [LocationSuiteName] = [
            .init(location: "London", suiteName: "253FAFE2-96C6-42AF-8908-33DA339BD6C7")
        ]
        
        if let encodedLocationsSuiteNames = getEncodedLocationsSuiteNames(forLocationsSuiteNames: locationsSuiteNames) {
            userDefaults.register(defaults: [
                "locations": encodedLocationsSuiteNames
            ])
        }
        
        return userDefaults
    }
    
    private func getEncodedLocationsSuiteNames(forLocationsSuiteNames locationsSuiteNames: [LocationSuiteName]) -> Data? {
        let encoder = JSONEncoder()
        
        return try? encoder.encode(locationsSuiteNames)
    }
    
}
