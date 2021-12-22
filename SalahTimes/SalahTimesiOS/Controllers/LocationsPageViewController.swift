//
//  LocationsPageViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 20/12/2021.
//

import UIKit
import SalahTimes

public final class LocationsPageViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var suiteNames: [String] {
        get {
            userDefaults.stringArray(forKey: "suiteNames") ?? ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
        }
        set {
            userDefaults.set(newValue, forKey: "suiteNames")
        }
    }
    private var salahTimesViewControllers = [UINavigationController]()
    
    private var currentIndex: Int {
        guard let currentViewController = pageViewController.viewControllers?.first as? UINavigationController,
              let index = salahTimesViewControllers.firstIndex(of: currentViewController) else { return 0 }
        
        return index
    }
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        loadSalahTimesViewControllersForLocations()
        setupPageViewController()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundGradient.frame = view.bounds
    }
    
    private let backgroundGradient = CAGradientLayer()
    
    private func setupBackground() {
        let purple = UIColor(red: 0.45, green: 0.40, blue: 1.00, alpha: 1.00).cgColor
        let blue = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
        
        backgroundGradient.type = .axial
        backgroundGradient.colors = [blue, purple]
        backgroundGradient.startPoint = .init(x: 0, y: 0)
        backgroundGradient.endPoint = .init(x: 0.25, y: 1)
        
        backgroundGradient.frame = view.bounds
        view.layer.addSublayer(backgroundGradient)
    }
    
    private func setupPageViewController() {
        add(pageViewController)
        pageViewController.view.fillSuperview()
        
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([salahTimesViewControllers[0]], direction: .forward, animated: true)
    }
    
    private func loadSalahTimesViewControllersForLocations() {
        let client = URLSessionHTTPClient()
        
        for suiteName in suiteNames {
            let salahTimesViewController = makeSalahTimesViewController(client: client, suiteName: suiteName)
            let navigationController = UINavigationController(rootViewController: salahTimesViewController)
            
            salahTimesViewControllers.append(navigationController)
        }
    }
    
    private func addLocation() {
        let client = URLSessionHTTPClient()
        let suiteName = UUID().uuidString
        suiteNames.append(suiteName)
        let navigationController = UINavigationController(rootViewController: makeSalahTimesViewController(client: client, suiteName: suiteName))
        
        salahTimesViewControllers.append(navigationController)
        pageViewController.setViewControllers([salahTimesViewControllers[salahTimesViewControllers.count-1]], direction: .forward, animated: true)
    }
    
    private func makeSalahTimesViewController(client: HTTPClient, suiteName: String) -> SalahTimesViewController {
        let salahTimesLoader = SalahTimesLoader(client: client)
        let userDefaults = getBaseUserDefaults(usingSuiteName: suiteName)
        let salahTimesViewController = SalahTimesViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults)
        salahTimesViewController.title = "Salāh Times"
        salahTimesViewController.onAddLocation = addLocation

        return salahTimesViewController
    }
    
    private func getBaseUserDefaults(usingSuiteName suiteName: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
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

extension LocationsPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let navController = viewController as? UINavigationController,
              let index = salahTimesViewControllers.firstIndex(of: navController),
              index != 0 else {
                  return nil
        }
        
        return salahTimesViewControllers[index-1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let navController = viewController as? UINavigationController,
              let index = salahTimesViewControllers.firstIndex(of: navController),
              index != salahTimesViewControllers.count-1 else {
                  return nil
        }
        
        return salahTimesViewControllers[index+1]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return salahTimesViewControllers.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
}
