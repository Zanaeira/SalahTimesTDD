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
    private let fajrIshaSettingsView = FajrIshaSettingsView(frame: .zero)
    private let deleteButton = UIButton()
    
    private let userDefaults: UserDefaults
    private let onDismiss: (() -> Void)?
    private let onDelete: (() -> Void)?
    
    public init(userDefaults: UserDefaults, onDismiss: ((() -> Void))?, onDelete: (() -> Void)?) {
        self.userDefaults = userDefaults
        self.settingsTableViewController = SettingsTableViewController(userDefaults: userDefaults)
        self.onDismiss = onDismiss
        self.onDelete = onDelete
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        setupLocationLabel()
        configureSettingsTableView()
        setupFajrIshaSettingsView()
        setupDeleteButton()
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
        settingsTableViewController.view.anchor(top: locationLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: leftInset, bottom: 0, right: rightInset))
        settingsTableViewController.view.constrainHeight(constant: 120)
    }
        
    func setLocation(_ location: String) {
        locationLabel.text = location
    }
    
    private func setupFajrIshaSettingsView() {
        view.addSubview(fajrIshaSettingsView)
        fajrIshaSettingsView.anchor(top: settingsTableViewController.view.bottomAnchor, leading: settingsTableViewController.view.leadingAnchor, bottom: nil, trailing: settingsTableViewController.view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        deleteButton.centerXInSuperview()
        deleteButton.topAnchor.constraint(equalTo: fajrIshaSettingsView.bottomAnchor, constant: 16).isActive = true
    }
    
    @objc private func deleteButtonPressed() {
        let deleteActionSheet = UIAlertController(title: "Are you sure you want to delete this location?", message: "", preferredStyle: .actionSheet)
        deleteActionSheet.addAction(.init(title: "Delete", style: .destructive, handler: { action in
            self.onDelete?()
        }))
        deleteActionSheet.addAction(.init(title: "Cancel", style: .cancel))
        
        present(deleteActionSheet, animated: true)
    }
        
}

private class FajrIshaSettingsView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    private func configureUI() {
        setupBackgroundAndBorder()
        setupLabel()
    }
    
    private func setupBackgroundAndBorder() {
        backgroundColor = .systemTeal.withAlphaComponent(0.4)
        layer.cornerRadius = 12
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
    }
    
    private func setupLabel() {
        label.text = """
        Fajr & Isha calculation: 12º.
        In future updates, this setting will be customisable, In Shā Allah.
        """
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        let stackView = UIStackView(arrangedSubviews: [label])
        if #available(iOS 15, *) {
            stackView.maximumContentSizeCategory = .accessibilityMedium
        } else {
            label.font = preferredFontForSettingsLabels()
        }
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    // TODO: - Get rid of this if not needed
    private func preferredFontForSettingsLabels() -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
        
        return UIFont(descriptor: fontDescriptor, size: min(fontDescriptor.pointSize, 30))
    }
    
}
