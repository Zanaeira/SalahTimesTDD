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
    private let fajr = SingleSalahTimeView()
    private let sunrise = SingleSalahTimeView()
    private let zuhr = SingleSalahTimeView()
    private let asr = SingleSalahTimeView()
    private let maghrib = SingleSalahTimeView()
    private let isha = SingleSalahTimeView()
    
    private var times: [SingleSalahTimeView] {
        [fajr, sunrise, zuhr, asr, maghrib, isha]
    }
    
    private lazy var topTimesStackView = UIStackView(arrangedSubviews: [
        fajr, sunrise, zuhr
    ])
    private lazy var bottomTimesStackView = UIStackView(arrangedSubviews: [
        asr, maghrib, isha
    ])
    private lazy var timesStackView = UIStackView(arrangedSubviews: [topTimesStackView, bottomTimesStackView])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    private func configureUI() {
        [topTimesStackView, bottomTimesStackView].forEach { $0.distribution = .fillEqually }
        
        timesStackView.axis = .horizontal
        timesStackView.distribution = .fillEqually
        timesStackView.spacing = 2
        
        let outerStackView = UIStackView(arrangedSubviews: [locationLabel, timesStackView])
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
        for (singleSalahTimeView, times) in zip(times, overviewCellModel.times) {
            singleSalahTimeView.configure(with: times)
        }
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
        if traitCollection.preferredContentSizeCategory > .medium {
            timesStackView.axis = .vertical
        } else {
            timesStackView.axis = .horizontal
        }
        
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            [topTimesStackView, bottomTimesStackView].forEach { $0.axis = .vertical }
        } else {
            [topTimesStackView, bottomTimesStackView].forEach { $0.axis = .horizontal }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateStackViews()
    }
    
}
