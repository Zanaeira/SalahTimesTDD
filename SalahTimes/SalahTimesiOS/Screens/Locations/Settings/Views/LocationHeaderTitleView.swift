//
//  LocationHeaderTitleView.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit

final class LocationHeaderTitleView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupLabel()
        configureUI()
    }
    
    func setLocation(_ location: String) {
        label.text = location
    }
    
    private func setupLabel() {
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .center
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [label])
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
