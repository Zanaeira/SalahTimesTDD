//
//  DeleteCell.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit

final class DeleteCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [deleteButton])
    
    private let deleteButton = UIButton()
    private var onDelete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupBackground()
        setupDeleteButton()
        setupStackView()
    }
    
    func setDeleteAction(_ action: @escaping () -> Void) {
        self.onDelete = action
    }
    
    private func setupBackground() {
        backgroundColor = .clear
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    private func setupStackView() {
        configureStackViewBackgroundAndBorder()
        
        contentView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    private func configureStackViewBackgroundAndBorder() {
        stackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 16
        stackView.layer.borderColor = UIColor.systemRed.cgColor
        stackView.layer.borderWidth = 1
    }
    
    @objc private func deleteButtonPressed() {
        onDelete?()
    }

}
