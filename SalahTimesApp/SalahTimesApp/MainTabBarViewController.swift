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
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let userDefaults = getUserDefaults()
        
        let salahTimesLoader = SalahTimesLoader(client: client)
        let salahTimesViewController = SalahTimesViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults)
        salahTimesViewController.title = "Salāh Times"
        salahTimesViewController.tabBarItem.image = UIImage(systemName: "calendar")
        
        let settingsViewController = SettingsViewController(userDefaults: userDefaults)
        settingsViewController.title = "Settings"
        settingsViewController.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        
        viewControllers = [UINavigationController(rootViewController: salahTimesViewController), UINavigationController(rootViewController: settingsViewController)]
        tabBar.tintColor = .systemTeal
    }
    
    private func getUserDefaults() -> UserDefaults {
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [
            "Mithl": 2,
            "Location": "London"
        ])
        
        if let fajrIshaMethod = getEncodedFajrIshaMethod() {
            userDefaults.register(defaults: [
                "FajrIsha": fajrIshaMethod
            ])
        }
        
        return userDefaults
    }
    
    private func getEncodedFajrIshaMethod() -> Data? {
        let fajrIshaMethod = AladhanAPIEndpoint.Method.custom(methodSettings: .init(fajrAngle: 12.0, maghribAngle: nil, ishaAngle: 12.0))
        
        let encoder = JSONEncoder()
        return try? encoder.encode(fajrIshaMethod)
    }

    
}
