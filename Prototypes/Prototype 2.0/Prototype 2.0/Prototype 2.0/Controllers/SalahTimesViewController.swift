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
    private var location: String?
    
    private let salahTimesLoader: SalahTimesLoader
    
    init(salahTimesLoader: SalahTimesLoader) {
        self.salahTimesLoader = salahTimesLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupSearchBar()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemTeal
    }
    
    private func refresh() {
        if let location = location {
            print("Getting Salah Times for: \(location)")
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
