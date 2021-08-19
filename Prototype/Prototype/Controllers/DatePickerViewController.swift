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
        configureDoneButton()
        configureCancelButton()
        
        view.addSubview(datePicker)
        datePicker.centerInSuperview()
        datePicker.constrainWidth(constant: view.frame.width - 40)
        datePicker.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        view.addSubview(stackView)
        stackView.anchor(top: datePicker.bottomAnchor, leading: datePicker.leadingAnchor, bottom: nil, trailing: datePicker.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 0))
    }
    
    private func configureDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        doneButton.constrainHeight(constant: 50)
        doneButton.backgroundColor = .systemBlue
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.constrainHeight(constant: 50)
        cancelButton.backgroundColor = .systemBlue
    }
    
    @objc private func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
