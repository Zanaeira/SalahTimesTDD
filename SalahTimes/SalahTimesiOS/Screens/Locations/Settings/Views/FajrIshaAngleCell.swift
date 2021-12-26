//
//  FajrIshaAngleCell.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit

final class FajrIshaAngleCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    // TODO: - Get rid of this if not needed
    private func preferredFontForSettingsLabels() -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
        
        return UIFont(descriptor: fontDescriptor, size: min(fontDescriptor.pointSize, 30))
    }
    
}
