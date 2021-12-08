//
//  OverviewCell.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 23/08/2021.
//

import UIKit

final class OverviewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let salahTimesCollectionViewController = OverviewSalahTimesCollectionViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
    }
    
    private func configureUI() {
        contentView.addSubview(salahTimesCollectionViewController.view)
    }
    
    func configure(with item: OverviewItem) {
        salahTimesCollectionViewController.updateSnapshot(items: item.items)
        salahTimesCollectionViewController.setHeader(TitleHeader(headerText: item.header))
    }
    
}
