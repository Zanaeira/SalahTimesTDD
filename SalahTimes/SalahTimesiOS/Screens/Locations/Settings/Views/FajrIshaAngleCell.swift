//
//  FajrIshaAngleCell.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit
import SalahTimes

final class FajrIshaAngleCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    private let userDefaults: UserDefaults
    
    private let stackView = UIStackView()
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["12º", "15º", "18º"])
    
    init(userDefaults: UserDefaults, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.userDefaults = userDefaults
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    private func configureUI() {
        setupBackgroundAndBorder()
        setupLabel()
        setupCalculationMethodSegmentedControl()
        setupStackView()
    }
    
    private func setupBackgroundAndBorder() {
        backgroundColor = .systemTeal.withAlphaComponent(0.4)
        layer.cornerRadius = 12
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
    }
    
    private func setupLabel() {
        label.text = "Fajr & 'Ishā Angle"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
    }
    
    private func setupCalculationMethodSegmentedControl() {
        segmentedControl.selectedSegmentTintColor = .systemTeal
        
        let stackView = UIStackView(arrangedSubviews: [segmentedControl])
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        guard let loadedFajrIshaCalculationMethod = userDefaults.object(forKey: "FajrIsha") as? Data,
              let fajrIshaCalculationMethod: AladhanAPIEndpoint.Method = try? JSONDecoder().decode(AladhanAPIEndpoint.Method.self, from: loadedFajrIshaCalculationMethod),
              case let AladhanAPIEndpoint.Method.custom(methodSettings) = fajrIshaCalculationMethod else {
            return
        }
        
        switch methodSettings.fajrAngle {
        case 12.0: segmentedControl.selectedSegmentIndex = 0
        case 15.0: segmentedControl.selectedSegmentIndex = 1
        case 18.0: segmentedControl.selectedSegmentIndex = 2
        default: return
        }
    }
    
    private func setupStackView() {
        [label, segmentedControl].forEach(stackView.addArrangedSubview)
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        addInsetsToStackView(inset: 16)
    }
        
    private func addInsetsToStackView(inset: CGFloat) {
        stackView.layoutMargins = .init(top: inset, left: inset, bottom: inset, right: inset)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
        
}
