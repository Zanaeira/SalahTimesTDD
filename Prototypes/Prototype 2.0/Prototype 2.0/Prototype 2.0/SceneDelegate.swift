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
        window?.rootViewController = NavigationController(rootViewController: salahTimesViewController).controller
        window?.makeKeyAndVisible()
    }
    
}

private final class NavigationController {
    
    let controller: UINavigationController
    
    init(rootViewController viewController: UIViewController) {
        controller = UINavigationController(rootViewController: viewController)
        
        configureUI()
    }
    
    private func configureUI() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
            
            controller.navigationBar.standardAppearance = appearance
            controller.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
}
