//
//  SettingsTableViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit

final class SettingsTableViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let tableView = UITableView()
    private let userDefaults: UserDefaults
    
    private lazy var cells: [UITableViewCell] = [MithlCell(userDefaults: userDefaults)]
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupTableView()
    }
    
    private func configureUI() {
        tableView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(tableView)
        tableView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor)
        
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
    }
    
}

extension SettingsTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
}