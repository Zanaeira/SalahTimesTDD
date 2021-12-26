//
//  MithlCell.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit

final class MithlCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let stackView = UIStackView()
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["1st Mithl", "2nd Mithl"])
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        super.init(style: .default, reuseIdentifier: nil)
        
        configureCell()
    }
    
    private func configureCell() {
        configureUI()
        setupLabel()
        setupSegmentedController()
        setupStackView()
    }
    
    private func configureUI() {
        backgroundColor = .clear
    }
    
    private func setupLabel() {
        label.text = "'Asr Mithl"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
    }
    
    private func setupSegmentedController() {
        let preferredMithl = userDefaults.integer(forKey: "Mithl")
        segmentedControl.selectedSegmentIndex = preferredMithl == 1 ? 0 : 1
        segmentedControl.selectedSegmentTintColor = .systemTeal
        segmentedControl.addTarget(self, action: #selector(mithlChanged), for: .valueChanged)
    }
    
    @objc private func mithlChanged() {
        let preferredMithl = segmentedControl.selectedSegmentIndex == 0 ? 1 : 2
        
        userDefaults.set(preferredMithl, forKey: "Mithl")
    }
    
    private func setupStackView() {
        [label, segmentedControl].forEach(stackView.addArrangedSubview)
        stackView.axis = .vertical
        stackView.spacing = 8
        
        // TODO: - Get rid of this if not needed
        if #available(iOS 15, *) {
            stackView.maximumContentSizeCategory = .accessibilityMedium
        } else {
            label.font = preferredFontForSettingsLabels()
        }
        
        contentView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        configureStackViewBackgroundAndBorder()
        addInsetsToStackView(inset: 16)
    }
    
    // TODO: - Get rid of this if not needed
    private func preferredFontForSettingsLabels() -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
        
        return UIFont(descriptor: fontDescriptor, size: min(fontDescriptor.pointSize, 30))
    }
    
    private func configureStackViewBackgroundAndBorder() {
        stackView.backgroundColor = .systemTeal.withAlphaComponent(0.4)
        stackView.layer.cornerRadius = 16
        stackView.layer.borderColor = UIColor.label.cgColor
        stackView.layer.borderWidth = 1
    }
    
    private func addInsetsToStackView(inset: CGFloat) {
        stackView.layoutMargins = .init(top: inset, left: inset, bottom: inset, right: inset)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
}
