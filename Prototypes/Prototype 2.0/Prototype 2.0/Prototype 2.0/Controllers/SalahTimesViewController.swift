//
//  SalahTimesViewController.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import UIKit

final class SalahTimesViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let searchController = UISearchController()
    private var defaultLocation = "London"
    private var location: String?
    private lazy var salahTimesCollectionViewController = SalahTimesCollectionViewController(onRefresh: refresh)
    
    private let salahTimesLoader: SalahTimesLoader
    
    init(salahTimesLoader: SalahTimesLoader) {
        self.salahTimesLoader = salahTimesLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupSearchBar()
        setupSalahTimesCollectionView()
        performInitialDataLoad()
    }
    
    private func configureUI() {
        setupGradientBackground()
    }
    
    private func setupGradientBackground() {
        let purple = UIColor(red: 0.45, green: 0.40, blue: 1.00, alpha: 1.00).cgColor
        let blue = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
        
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [blue, purple]
        gradient.startPoint = .init(x: 0, y: 0)
        gradient.endPoint = .init(x: 0.25, y: 1)
        
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    private func setupSalahTimesCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        add(salahTimesCollectionViewController)
        salahTimesCollectionViewController.view.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    private func performInitialDataLoad() {
        refresh()
    }
    
    private func refresh() {
        salahTimesLoader.loadTimes(from: location ?? defaultLocation) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResult(result)
            }
        }
    }
    
    private func handleResult(_ result: SalahTimesLoader.Result) {
        switch result {
        case .success(let salahTimes):
            self.salahTimesCollectionViewController.updateSalahTimes(salahTimes, for: location ?? defaultLocation)
            print(salahTimes)
        case .failure:
            break
        }
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        location = searchBar.text
        searchController.isActive = false
        refresh()
    }
    
}
