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
    
    private let deleteCell = DeleteCell(style: .default, reuseIdentifier: nil)
    
    private lazy var cells: [UITableViewCell] = [MithlCell(userDefaults: userDefaults),
                                                 FajrIshaAngleCell(style: .default, reuseIdentifier: nil),
                                                 deleteCell]
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    func setDeleteAction(deleteAction: @escaping () -> Void) {
        deleteCell.setDeleteAction(deleteAction)
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
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension SettingsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
