//
//  HeaderViewBuilder.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 04/12/2021.
//

import UIKit

final class HeaderViewBuilder {
    
    private init() {}
    
    static func buildHeaderView(withTitle title: String, onDateSelectedAction onDateSelected: @escaping () -> Void) -> HeaderView {
        let headerView = HeaderView(frame: .zero)
        headerView.setTitle(title)
        headerView.onDateSelected = onDateSelected
        
        return headerView
    }
    
}

final class HeaderView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    private let datePicker = UIDatePicker()
    
    fileprivate var onDateSelected: (() -> Void)?
    
    var selectedDate: Date {
        datePicker.date
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    fileprivate func configure() {
        configureDatePicker()
        
        let stackView = UIStackView(arrangedSubviews: [label, datePicker])
        stackView.axis = .vertical
        stackView.spacing = 6
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.textColor = .white
        
        backgroundColor = .systemBlue.withAlphaComponent(0.4)
        
        layer.cornerRadius = 8
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .center
        datePicker.addTarget(self, action: #selector(callOnDateSelected), for: .valueChanged)
    }
    
    @objc private func callOnDateSelected() {
        onDateSelected?()
    }
    
}
