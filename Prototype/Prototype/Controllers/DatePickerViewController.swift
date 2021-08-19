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
    private let dismissViewButton = UIButton()
    
    init(mode: UIDatePicker.Mode, style: UIDatePickerStyle) {
        super.init(nibName: nil, bundle: nil)
        
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = style
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        configure()
    }
    
    private func configure() {
        configureDismissButton()
        configure(doneButton, title: "Done", selector: #selector(doneButtonPressed))
        configure(cancelButton, title: "Cancel", selector: #selector(dismissDatePickerView))
        
        view.addSubview(datePicker)
        datePicker.centerInSuperview()
        datePicker.constrainWidth(constant: view.frame.width - 40)
        datePicker.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        view.addSubview(stackView)
        stackView.anchor(top: datePicker.bottomAnchor, leading: datePicker.leadingAnchor, bottom: nil, trailing: datePicker.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    private func configureDismissButton() {
        view.addSubview(dismissViewButton)
        dismissViewButton.fillSuperview()
        dismissViewButton.addTarget(self, action: #selector(dismissDatePickerView), for: .touchUpInside)
    }
    
    private func configure(_ button: UIButton, title: String, selector: Selector) {
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.constrainHeight(constant: 50)
        button.backgroundColor = .systemBlue
    }
    
    @objc private func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissDatePickerView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
