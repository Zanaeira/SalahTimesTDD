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
    
    private let stackView = UIStackView()
    
    private let nameLabel = SingleSalahTimeView.dynamicLabel(font: .preferredFont(forTextStyle: .title3))
    private let timeLabel = SingleSalahTimeView.dynamicLabel(font: .preferredFont(forTextStyle: .title3))
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
        
    private func configureUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        
        [imageView, nameLabel, timeLabel].forEach(stackView.addArrangedSubview)
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
        label.numberOfLines = 0
        label.textAlignment = textAlignment
        label.font = font
        
        return label
    }
    
}
