//
//  SceneDelegate.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 04/12/2021.
//

import UIKit
import SalahTimes
import SalahTimesiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let userDefaults = getUserDefaults()
        
        let client = URLSessionHTTPClient()
        let salahTimesLoader = SalahTimesLoader(client: client)
        let salahTimesViewController = SalahTimesViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults)
        salahTimesViewController.title = "Salāh Times"
        salahTimesViewController.tabBarItem.image = UIImage(systemName: "calendar")
        
        let settingsViewController = SettingsViewController(userDefaults: userDefaults)
        settingsViewController.title = "Settings"
        settingsViewController.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UINavigationController(rootViewController: salahTimesViewController), UINavigationController(rootViewController: settingsViewController)]
        tabBarController.tabBar.tintColor = .systemTeal
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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
