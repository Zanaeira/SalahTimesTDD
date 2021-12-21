//
//  SalahTimesViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import UIKit
import SalahTimes

public final class SalahTimesViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let searchController = UISearchController()
    private let salahTimesCollectionViewController: SalahTimesCollectionViewController
    
    private let settingsViewController: SettingsViewController
    
    public init(salahTimesLoader: SalahTimesLoader, userDefaults: UserDefaults) {
        self.salahTimesCollectionViewController = SalahTimesCollectionViewController(salahTimesLoader: salahTimesLoader, userDefaults: userDefaults)
        self.settingsViewController = SettingsViewController(userDefaults: userDefaults, onDismiss: salahTimesCollectionViewController.refresh)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    func setLocation(_ location: String) {
        salahTimesCollectionViewController.updateLocation(to: location)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupSalahTimesCollectionView()
        setupSettingsButtonAndViewController()
    }
    
    private func setupSettingsButtonAndViewController() {
        navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(openSettings))
        navigationController?.navigationBar.tintColor = .systemTeal
    }
    
    @objc private func openSettings() {
        settingsViewController.view.backgroundColor = .systemBackground
        present(settingsViewController, animated: true)
    }
    
    private func setupSalahTimesCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        add(salahTimesCollectionViewController)
        salahTimesCollectionViewController.view.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    
}

// MARK: - Search Controller functionality
extension SalahTimesViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.placeholder = "Enter location. E.g. London"
        
        searchController.searchBar.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func dismissKeyboard() {
        searchController.isActive = false
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text else {
            return
        }
        
        salahTimesCollectionViewController.updateLocation(to: location)
        searchController.isActive = false
    }
    
}
