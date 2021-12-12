//
//  SceneDelegate.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let salahTimesLoader = SalahTimesLoader()
        
        let salahTimesViewController = SalahTimesViewController(salahTimesLoader: salahTimesLoader)
        salahTimesViewController.title = "Salāh Times"
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: salahTimesViewController)
        window?.makeKeyAndVisible()
    }
    
}
