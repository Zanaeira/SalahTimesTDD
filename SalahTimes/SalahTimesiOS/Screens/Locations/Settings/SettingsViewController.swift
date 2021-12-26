//
//  SettingsViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 14/12/2021.
//

import UIKit

public final class SettingsViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let backgroundGradient = CAGradientLayer()
    
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = 20
    
    private let locationLabel = UILabel()
    private let settingsTableViewController: SettingsTableViewController
    
    private let onDismiss: (() -> Void)?
    private let onDelete: (() -> Void)?
    
    public init(userDefaults: UserDefaults, onDismiss: ((() -> Void))?, onDelete: (() -> Void)?) {
        self.settingsTableViewController = SettingsTableViewController(userDefaults: userDefaults)
        self.onDismiss = onDismiss
        self.onDelete = onDelete
        
        super.init(nibName: nil, bundle: nil)
        
        settingsTableViewController.setDeleteAction(deleteAction: deleteButtonPressed)
    }
    
    func setLocation(_ location: String) {
        locationLabel.text = location
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        setupLocationLabel()
        configureSettingsTableView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundGradient.frame = view.bounds
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        onDismiss?()
    }
    
    private func setupGradientBackground() {
        let purple = UIColor(red: 0.45, green: 0.40, blue: 1.00, alpha: 1.00).cgColor
        let blue = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
        
        backgroundGradient.type = .axial
        backgroundGradient.colors = [blue, purple]
        backgroundGradient.startPoint = .init(x: 0, y: 0)
        backgroundGradient.endPoint = .init(x: 0.25, y: 1)
        
        backgroundGradient.frame = view.bounds
        view.layer.addSublayer(backgroundGradient)
    }
    
    private func setupLocationLabel() {
        locationLabel.font = .preferredFont(forTextStyle: .title1)
        locationLabel.adjustsFontForContentSizeCategory = true
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [locationLabel])
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(stackView)
        stackView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 30, left: leftInset, bottom: 0, right: rightInset))
    }
    
    private func configureSettingsTableView() {
        add(settingsTableViewController)
        
        let safeArea = view.safeAreaLayoutGuide
        settingsTableViewController.view.anchor(top: locationLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: leftInset, bottom: 16, right: rightInset))
    }
    
    private func deleteButtonPressed() {
        let deleteActionSheet = UIAlertController(title: "Are you sure you want to delete this location?", message: "", preferredStyle: .actionSheet)
        deleteActionSheet.addAction(.init(title: "Delete", style: .destructive, handler: { action in
            self.onDelete?()
        }))
        deleteActionSheet.addAction(.init(title: "Cancel", style: .cancel))
        
        present(deleteActionSheet, animated: true)
    }
        
}
