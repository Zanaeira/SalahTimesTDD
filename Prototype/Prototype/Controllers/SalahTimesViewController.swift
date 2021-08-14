//
//  SalahTimesViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 13/08/2021.
//

import UIKit

final class SalahTimesViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        configureUI()
        setupSearchButton()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemTeal
        
        title = "Salah Times"
    }
    
    private func setupSearchButton() {
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        searchBar.showsCancelButton = true
    }
    
    @objc private func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    private func hideSearchBar() {
        setupSearchButton()
    }
    
}

extension SalahTimesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
}
