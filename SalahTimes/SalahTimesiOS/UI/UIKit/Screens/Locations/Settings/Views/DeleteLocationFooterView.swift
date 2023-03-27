//
//  DeleteLocationFooterView.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 26/12/2021.
//

import UIKit

final class DeleteLocationFooterView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let stackView = UIStackView()
    private let button = UIButton()
    
    private var onDelete: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        setupDeleteButton()
        setupStackView()
        
    }
    
    func setDeleteAction(_ action: @escaping () -> Void) {
        self.onDelete = action
    }
    
    private func configureUI() {
        backgroundColor = .clear
    }
    
    private func setupDeleteButton() {
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(button)
        addInsetsToStackView(inset: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
        
    private func addInsetsToStackView(inset: CGFloat) {
        stackView.layoutMargins = .init(top: inset, left: 0, bottom: inset, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    @objc private func deleteButtonPressed() {
        onDelete?()
    }
    
}
