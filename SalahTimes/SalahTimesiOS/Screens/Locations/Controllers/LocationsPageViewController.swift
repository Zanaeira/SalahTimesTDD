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
    
    private let client: HTTPClient
    private let userDefaults: UserDefaults
    
    public init(client: HTTPClient, userDefaults: UserDefaults) {
        self.client = client
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
        
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers([self.salahTimesViewControllers[0]], direction: .forward, animated: true)
        }
    }
    
    private func loadSalahTimesViewControllersForLocations() {
        for suiteName in suiteNames {
            let salahTimesViewController = makeSalahTimesViewController(suiteName: suiteName)
            let navigationController = UINavigationController(rootViewController: salahTimesViewController)
            
            salahTimesViewControllers.append(navigationController)
        }
    }
    
    private func promptToAddLocation() {
        let alertController = UIAlertController(title: "Add Location", message: "Enter the location you would like to add", preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?.first?.autocapitalizationType = .words
        
        let addLocationAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let locationToAdd = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespaces),
                  !locationToAdd.isEmpty else {
                return
            }
            
            self?.addLocation(locationToAdd)
        }
        
        alertController.addAction(addLocationAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func addLocation(_ location: String) {
        let suiteName = UUID().uuidString
        suiteNames.append(suiteName)
        let navigationController = UINavigationController(rootViewController: makeSalahTimesViewController(suiteName: suiteName, forLocation: location))
        
        salahTimesViewControllers.append(navigationController)
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers([self.salahTimesViewControllers[self.salahTimesViewControllers.count-1]], direction: .forward, animated: true)
        }
    }
    
    private func makeSalahTimesViewController(suiteName: String, forLocation location: String = "London") -> SalahTimesViewController {
        let salahTimesLoader = SalahTimesLoader(client: client)
        let userDefaults = getBaseUserDefaults(usingSuiteName: suiteName, forLocation: location)
        let salahTimesViewController = SalahTimesViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults, onDelete: {
            self.dismiss(animated: true)
            self.deleteLocation(suiteName: suiteName)
        })
        salahTimesViewController.title = "Salāh Times"
        salahTimesViewController.onAddLocation = promptToAddLocation

        return salahTimesViewController
    }
    
    private func getBaseUserDefaults(usingSuiteName suiteName: String, forLocation location: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        userDefaults.register(defaults: [
            "Mithl": 2,
            "Location": location
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
    
    private func deleteLocation(suiteName: String) {
        if suiteNames.count == 1 {
            let alert = UIAlertController(title: "Cannot delete", message: "You cannot delete a location if you do not have more than one location.", preferredStyle: .alert)
            alert.addAction(.init(title: "Dismiss", style: .default))
            
            present(alert, animated: true)
            return
        }
        
        let newIndex: Int
        let direction: UIPageViewController.NavigationDirection
        
        if currentIndex == 0 {
            newIndex = 0
            direction = .reverse
        } else if currentIndex == salahTimesViewControllers.count - 1 {
            newIndex = currentIndex - 1
            direction = .reverse
        } else {
            newIndex = currentIndex
            direction = .forward
        }
        
        suiteNames.remove(at: currentIndex)
        salahTimesViewControllers.remove(at: currentIndex)
        
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers([self.salahTimesViewControllers[newIndex]], direction: direction, animated: true)
        }
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
        togglePageControlVisibilityIfOnlyOneViewController()
        return salahTimesViewControllers.count
    }
    
    private func togglePageControlVisibilityIfOnlyOneViewController() {
        let hidden = salahTimesViewControllers.count == 1 ? true : false
        
        for subview in pageViewController.view.subviews where subview is UIPageControl {
            subview.isHidden = hidden
        }
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
}
