//
//  DatePickerViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 19/08/2021.
//

import UIKit

final class DatePickerViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let datePicker = UIDatePicker()
    private let doneButton = UIButton()
    private let cancelButton = UIButton()
    private let dismissView = UIView()
    
    private let onDateSelected: (Date) -> Void
    
    init(mode: UIDatePicker.Mode, style: UIDatePickerStyle, initialDate: Date, onDateSelected: @escaping (Date) -> Void) {
        self.onDateSelected = onDateSelected
        
        super.init(nibName: nil, bundle: nil)
        
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = style
        
        datePicker.date = initialDate
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        configure()
    }
    
    private func configure() {
        configureDismissView()
        configure(doneButton, title: "Done", selector: #selector(doneButtonPressed))
        configure(cancelButton, title: "Cancel", selector: #selector(dismissDatePickerView))
        
        view.addSubview(datePicker)
        datePicker.centerInSuperview()
        datePicker.constrainWidth(constant: view.frame.width - 8)
        datePicker.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        view.addSubview(stackView)
        stackView.anchor(top: datePicker.bottomAnchor, leading: datePicker.leadingAnchor, bottom: nil, trailing: datePicker.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    private func configureDismissView() {
        view.addSubview(dismissView)
        dismissView.backgroundColor = .clear
        dismissView.fillSuperview()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDatePickerView))
        dismissView.addGestureRecognizer(tapRecognizer)
    }
    
    private func configure(_ button: UIButton, title: String, selector: Selector) {
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.constrainHeight(constant: 50)
        button.backgroundColor = .systemBlue
    }
    
    @objc private func doneButtonPressed() {
        onDateSelected(datePicker.date)
        
        dismissDatePickerView()
    }
    
    @objc private func dismissDatePickerView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
