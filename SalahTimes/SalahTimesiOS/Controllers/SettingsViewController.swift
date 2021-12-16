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
    
    private let leftInset: CGFloat = 40
    private let rightInset: CGFloat = 40
    
    private let segmentedController = UISegmentedControl(items: ["Mithl 1", "Mithl 2"])
    private let asrStackView = UIStackView()
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupAsrTimingSettings()
        setupFajrIshaSettingsView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundGradient.frame = view.bounds
    }
    
    private func configureUI() {
        setupGradientBackground()
        segmentedController.selectedSegmentTintColor = .systemTeal
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

    
    private func setupAsrTimingSettings() {
        let asrLabel = UILabel()
        asrLabel.text = "'Asr Mithl"
        asrLabel.adjustsFontForContentSizeCategory = true
        asrLabel.font = .preferredFont(forTextStyle: .title3)
        asrLabel.textAlignment = .center
        let preferredMithl = userDefaults.integer(forKey: "Mithl")
        segmentedController.selectedSegmentIndex = preferredMithl == 2 ? 1 : 0
        segmentedController.addTarget(self, action: #selector(mithlChanged), for: .valueChanged)
        
        let safeArea = view.safeAreaLayoutGuide
        let topInset: CGFloat = 60
        
        asrStackView.axis = .vertical
        asrStackView.spacing = 8
        asrStackView.maximumContentSizeCategory = .accessibilityMedium
        
        asrStackView.addArrangedSubview(asrLabel)
        asrStackView.addArrangedSubview(segmentedController)
        view.addSubview(asrStackView)
        asrStackView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: topInset, left: leftInset, bottom: 0, right: rightInset))
        
        asrStackView.backgroundColor = .systemTeal.withAlphaComponent(0.4)
        let stackViewInset: CGFloat = 16
        asrStackView.layoutMargins = .init(top: stackViewInset, left: stackViewInset, bottom: stackViewInset, right: stackViewInset)
        asrStackView.isLayoutMarginsRelativeArrangement = true
        
        asrStackView.layer.cornerRadius = 16
        asrStackView.layer.borderColor = UIColor.label.cgColor
        asrStackView.layer.borderWidth = 1
    }
    
    private func setupFajrIshaSettingsView() {
        let fajrIshaSettingsView = FajrIshaSettingsView(frame: .zero)
        view.addSubview(fajrIshaSettingsView)
        fajrIshaSettingsView.anchor(top: asrStackView.bottomAnchor, leading: asrStackView.leadingAnchor, bottom: nil, trailing: asrStackView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    @objc private func mithlChanged() {
        let preferredMithl = segmentedController.selectedSegmentIndex == 0 ? 1 : 2
        
        userDefaults.set(preferredMithl, forKey: "Mithl")
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
        This app defaults to calculating the times for Fajr and Isha using 12.0º. In future updates, this setting will be customisable, In Shā Allah.
        """
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.maximumContentSizeCategory = .accessibilityMedium
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
}
