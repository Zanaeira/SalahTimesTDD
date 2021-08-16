//
//  SalahTimesViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 13/08/2021.
//

import UIKit

final class SalahTimesViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tomorrowView = TomorrowView()
    private let salahTimesCollectionViewController = SalahTimesCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        title = "Salah Times"
        
        setupNavigationBar()
        setupTomorrowView()
        setupSalahTimesCollectionView()
    }
    
    private func setupNavigationBar() {
        setupSearchButton()
        setupAddLocationButton()
    }
    
    private func setupTomorrowView() {
        view.addSubview(tomorrowView)
        
        let safeArea = view.safeAreaLayoutGuide
        tomorrowView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        tomorrowView.constrainHeight(constant: 100)
    }
    
    private func setupSalahTimesCollectionView() {
        add(salahTimesCollectionViewController)
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

private final class TomorrowView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let fajrHeadingLabel = UILabel(text: "Fajr tomorrow is at:", font: .preferredFont(forTextStyle: .title3))
    private let sunriseHeadingLabel = UILabel(text: "Sunrise tomorrow is at:", font: .preferredFont(forTextStyle: .title3))
    private let fajrLabel = UILabel(text: "03:29", font: .preferredFont(forTextStyle: .title3))
    private let sunriseLabel = UILabel(text: "05:49", font: .preferredFont(forTextStyle: .title3))
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .systemBlue.withAlphaComponent(0.6)
        setupLabels()
    }
    
    private func setupLabels() {
        let headingsStackView = setupHeadingLabels()
        
        let timesStackView = UIStackView(arrangedSubviews: [fajrLabel, sunriseLabel])
        timesStackView.axis = .vertical
        addSubview(timesStackView)
        timesStackView.anchor(top: headingsStackView.topAnchor, leading: headingsStackView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
    }
    
    @discardableResult
    private func setupHeadingLabels() -> UIStackView {
        [fajrHeadingLabel, sunriseHeadingLabel].forEach({$0.textAlignment = .right})
        let headingsStackView = UIStackView(arrangedSubviews: [fajrHeadingLabel, sunriseHeadingLabel])
        headingsStackView.axis = .vertical
        addSubview(headingsStackView)
        headingsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        return headingsStackView
    }
    
}
