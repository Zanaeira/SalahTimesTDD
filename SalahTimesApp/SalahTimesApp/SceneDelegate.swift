//
//  SceneDelegate.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 04/12/2021.
//

import UIKit
import SalahTimes

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let client = URLSessionHTTPClient()
        let tabBarController = MainTabBarViewController(client: client)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
}
