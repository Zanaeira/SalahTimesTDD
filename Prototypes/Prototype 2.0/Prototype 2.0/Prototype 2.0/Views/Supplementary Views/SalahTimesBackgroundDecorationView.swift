//
//  SalahTimesBackgroundDecorationView.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 11/12/2021.
//

import UIKit

final class SalahTimesBackgroundDecorationView: UICollectionReusableView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 16
    }
    
}
