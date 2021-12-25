//
//  SalahImageNameTimeStackViewBuilder.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 23/12/2021.
//

import UIKit

final class SalahImageNameTimeView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    let stackView: UIStackView
    private let imageView: UIImageView
    private let nameLabel: UILabel
    private let timeLabel: UILabel
    
    fileprivate init(stackView: UIStackView, imageView: UIImageView, nameLabel: UILabel, timeLabel: UILabel) {
        self.stackView = stackView
        self.imageView = imageView
        self.nameLabel = nameLabel
        self.timeLabel = timeLabel
        
        super.init(frame: .zero)
    }
    
    func configure(with salahTimesCellModel: SalahTimesCellModel) {
        let image = UIImage(systemName: salahTimesCellModel.imageName)
        imageView.image = image
        nameLabel.text = salahTimesCellModel.name
        timeLabel.text = salahTimesCellModel.time
    }
    
}

final class SalahImageNameTimeStackViewBuilder {
    
    private init() {}
    
    static func build() -> SalahImageNameTimeView {
        let imageView = makeImageView()
        let nameLabel = dynamicLabel(font: .preferredFont(forTextStyle: .title3))
        let timeLabel = dynamicLabel(font: .preferredFont(forTextStyle: .title3))
        
        let stackView = makeStackView(fromArrangedSubviews: [imageView, nameLabel, timeLabel])
        
        return SalahImageNameTimeView(stackView: stackView, imageView: imageView, nameLabel: nameLabel, timeLabel: timeLabel)
    }
    
    private static func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        
        return imageView
    }
    
    private static func makeStackView(fromArrangedSubviews arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        
        return stackView
    }
    
    private static func dynamicLabel(font: UIFont = .preferredFont(forTextStyle: .title3), textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = textAlignment
        label.font = font
        
        return label
    }
    
}
