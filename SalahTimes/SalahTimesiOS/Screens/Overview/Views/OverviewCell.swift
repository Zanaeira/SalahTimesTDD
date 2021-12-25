//
//  OverviewCell.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 22/12/2021.
//

import UIKit

final class OverviewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let locationLabel = dynamicLabel(font: .preferredFont(forTextStyle: .title1))
    
    private var fajrStackView = SalahImageNameTimeStackViewBuilder.build()
    private var sunriseStackView = SalahImageNameTimeStackViewBuilder.build()
    private var zuhrStackView = SalahImageNameTimeStackViewBuilder.build()
    private var asrStackView = SalahImageNameTimeStackViewBuilder.build()
    private var maghribStackView = SalahImageNameTimeStackViewBuilder.build()
    private var ishaStackView = SalahImageNameTimeStackViewBuilder.build()
    
    private var timesStackViews: [UIStackView] {
        [fajrStackView.stackView, sunriseStackView.stackView, zuhrStackView.stackView, asrStackView.stackView, maghribStackView.stackView, ishaStackView.stackView]
    }
    
    private lazy var topTimesStackView = UIStackView(arrangedSubviews: [
        fajrStackView.stackView, sunriseStackView.stackView, zuhrStackView.stackView
    ])
    private lazy var bottomTimesStackView = UIStackView(arrangedSubviews: [
        asrStackView.stackView, maghribStackView.stackView, ishaStackView.stackView
    ])
    private lazy var bothRowsOfTimesStackView = UIStackView(arrangedSubviews: [topTimesStackView, bottomTimesStackView])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    private func configureUI() {
        updateStackViews()
        
        let outerStackView = UIStackView(arrangedSubviews: [locationLabel, bothRowsOfTimesStackView])
        outerStackView.axis = .vertical
        outerStackView.distribution = .fill
        outerStackView.spacing = 10
        outerStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        outerStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(outerStackView)
        outerStackView.fillSuperview()
        
        contentView.backgroundColor = .systemTeal.withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func configure(with overviewCellModel: OverviewCellModel) {
        locationLabel.text = overviewCellModel.location
        
        fajrStackView.configure(with: overviewCellModel.fajr)
        sunriseStackView.configure(with: overviewCellModel.sunrise)
        zuhrStackView.configure(with: overviewCellModel.zuhr)
        asrStackView.configure(with: overviewCellModel.asr)
        maghribStackView.configure(with: overviewCellModel.maghrib)
        ishaStackView.configure(with: overviewCellModel.isha)
    }
    
    private static func dynamicLabel(font: UIFont = .preferredFont(forTextStyle: .title3), textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = textAlignment
        label.font = font
        
        return label
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateStackViews()
    }
    
    private func updateStackViews() {
        let isAccessibility = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        
        [topTimesStackView, bottomTimesStackView].forEach { $0.distribution = .fillEqually }
        bothRowsOfTimesStackView.distribution = .fillEqually
        
        if !isAccessibility {
            timesStackViews.forEach {
                $0.axis = .vertical
                $0.distribution = .fill
            }
            topTimesStackView.axis = .horizontal
            bottomTimesStackView.axis = .horizontal
            if traitCollection.preferredContentSizeCategory > .medium {
                bothRowsOfTimesStackView.axis = .vertical
            } else {
                bothRowsOfTimesStackView.axis = .horizontal
            }
        } else {
            timesStackViews.forEach {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
            }
            topTimesStackView.axis = .vertical
            bottomTimesStackView.axis = .vertical
            bothRowsOfTimesStackView.axis = .vertical
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateStackViews()
    }
    
}
