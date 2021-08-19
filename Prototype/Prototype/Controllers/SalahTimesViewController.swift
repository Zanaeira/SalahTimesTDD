//
//  SalahTimesViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 13/08/2021.
//

import UIKit

final class SalahTimesViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let headerLabel = UILabel(text: "London, UK", font: .preferredFont(forTextStyle: .title1))
    private let tomorrowViewController = TomorrowViewController()
    private let salahTimesCollectionViewController = SalahTimesCollectionViewController(header: Header(date: Date()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        title = "Salah Times"
        
        setupNavigationBar()
        setupHeaderLabel()
        setupTomorrowView()
        setupSalahTimesCollectionView()
    }
    
    private func setupNavigationBar() {
        setupSearchButton()
        setupAddLocationButton()
    }
    
    private func setupHeaderLabel() {
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        headerLabel.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    private func setupTomorrowView() {
        add(tomorrowViewController)
        let tomorrowView: UIView! = tomorrowViewController.view
        
        let safeArea = view.safeAreaLayoutGuide
        tomorrowView.anchor(top: headerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: 20, bottom: 0, right: 20))
        tomorrowView.constrainHeight(constant: 100)
    }
    
    private func setupSalahTimesCollectionView() {
        add(salahTimesCollectionViewController)
        let tomorrowView: UIView! = tomorrowViewController.view
        
        let safeArea = view.safeAreaLayoutGuide
        salahTimesCollectionViewController.view.anchor(top: tomorrowView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    private func setupSearchButton() {
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        searchBar.showsCancelButton = true
    }
    
    @objc private func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    private func setupAddLocationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
    }
    
    @objc private func addLocation() {
        print("Add new location")
    }
    
}

extension SalahTimesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setupNavigationBar()
    }
    
}
