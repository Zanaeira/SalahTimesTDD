//
//  SettingsViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 14/12/2021.
//

import UIKit

public final class SettingsViewController: UIViewController {
    
    private let backgroundGradient = CAGradientLayer()
    
    private let leftInset: CGFloat = 40
    private let rightInset: CGFloat = 40
    
    private let segmentedController = UISegmentedControl(items: ["Mithl 1", "Mithl 2"])
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupAsrTimingSettings()
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
        asrLabel.text = "'Asr Method:"
        asrLabel.adjustsFontForContentSizeCategory = true
        segmentedController.selectedSegmentIndex = 1
        
        let safeArea = view.safeAreaLayoutGuide
        let topInset: CGFloat = 60
        
        let asrStackView = UIStackView(arrangedSubviews: [asrLabel, segmentedController])
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
    
}
