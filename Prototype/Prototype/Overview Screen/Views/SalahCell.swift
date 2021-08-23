//
//  SalahCell.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 23/08/2021.
//

import UIKit

final class SalahCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var salahCellRegistration: UICollectionView.CellRegistration<SalahCell, Item> {
        UICollectionView.CellRegistration<SalahCell, Item> { itemCell, indexPath, item in
            itemCell.configure(with: item)
        }
    }
    
    private let primaryLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .headline))
    private let secondaryLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .body))
    private let imageView = UIImageView()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, primaryLabel, secondaryLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.title.uppercased()
        secondaryLabel.text = item.body
        imageView.image = item.image
    }
    
    private func setupViews() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        
        contentView.addSubview(stackView)
        stackView.fillSuperview()
        
        primaryLabel.textAlignment = .center
        secondaryLabel.textAlignment = .center
    }
    
}
