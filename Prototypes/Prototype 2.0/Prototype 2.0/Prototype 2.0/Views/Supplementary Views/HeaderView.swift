//
//  HeaderView.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 11/12/2021.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    private let datePicker = UIDatePicker()
    
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
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        setupDatePicker()
        
        addSubview(datePicker)
        datePicker.centerXInSuperview()
        datePicker.anchor(top: label.bottomAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 2, left: 0, bottom: 10, right: 0))
    }
    
    private func setupLabel() {
        label.text = "London"
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .center
        datePicker.tintColor = .systemTeal
    }
    
    private func roundCorners(_ corners: UIRectCorner, byRadius radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
