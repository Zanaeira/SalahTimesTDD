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
    private let fajrLabel = dynamicLabel()
    private let sunriseLabel = dynamicLabel()
    private let zuhrLabel = dynamicLabel()
    private let asrLabel = dynamicLabel()
    private let maghribLabel = dynamicLabel()
    private let ishaLabel = dynamicLabel()
    
    private var timesLabels: [UILabel] {
        [fajrLabel, sunriseLabel, zuhrLabel, asrLabel, maghribLabel, ishaLabel]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    private func configureUI() {
        let topTimesStackView = UIStackView(arrangedSubviews: [
            fajrLabel, sunriseLabel, zuhrLabel
        ])
        let bottomTimesStackView = UIStackView(arrangedSubviews: [
            asrLabel, maghribLabel, ishaLabel
        ])
        
        let timesStackView = UIStackView(arrangedSubviews: [topTimesStackView, bottomTimesStackView])
        timesStackView.axis = .vertical
        timesStackView.spacing = 10
        
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
        for (label, times) in zip(timesLabels, overviewCellModel.times) {
            label.text = "\(times.name)\n\(times.time)"
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
    
}
