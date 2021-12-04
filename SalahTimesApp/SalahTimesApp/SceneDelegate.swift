//
//  SceneDelegate.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 04/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let mainController = UIViewController()
        mainController.view.backgroundColor = .systemPink
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()
    }
    
}
