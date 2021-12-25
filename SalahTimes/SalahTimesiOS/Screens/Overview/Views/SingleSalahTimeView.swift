//
//  SingleSalahTimeView.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 23/12/2021.
//

import UIKit

final class SingleSalahTimeView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, timeLabel])
    
    private let imageView = UIImageView()
    private let nameLabel = SingleSalahTimeView.dynamicLabel(font: .preferredFont(forTextStyle: .title3))
    private let timeLabel = SingleSalahTimeView.dynamicLabel(font: .preferredFont(forTextStyle: .title3))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
        
    private func configureUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    func configure(with salahTimesCellModel: SalahTimesCellModel) {
        let image = UIImage(systemName: salahTimesCellModel.imageName)
        imageView.image = image
        nameLabel.text = salahTimesCellModel.name
        timeLabel.text = salahTimesCellModel.time
    }
    
    private static func dynamicLabel(font: UIFont = .preferredFont(forTextStyle: .title3), textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = textAlignment
        label.font = font
        
        return label
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        updateStackView(isAccessibilityCategory: isAccessibilityCategory)
    }
    
    private func updateStackView(isAccessibilityCategory: Bool) {
        if isAccessibilityCategory {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
        } else {
            stackView.axis = .vertical
            stackView.distribution = .fill
        }
    }
    
}
