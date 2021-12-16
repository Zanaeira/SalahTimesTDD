//
//  HeaderView.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 11/12/2021.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topRight, .topLeft], byRadius: 16)
    }
    
    private func configureUI() {
        backgroundColor = .systemTeal.withAlphaComponent(0.4)
        
        setupLabel()
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    private func setupLabel() {
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
    }
    
    func setLabelText(_ text: String) {
        label.text = text
    }
    
    private func roundCorners(_ corners: UIRectCorner, byRadius radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
