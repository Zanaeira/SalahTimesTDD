//
//  TomorrowViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 18/08/2021.
//

import UIKit

final class TomorrowViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let fajrHeadingLabel = UILabel(text: "Fajr tomorrow is at:", font: .preferredFont(forTextStyle: .title3))
    private let sunriseHeadingLabel = UILabel(text: "Sunrise tomorrow is at:", font: .preferredFont(forTextStyle: .title3))
    private let fajrLabel = UILabel(text: "03:29", font: .preferredFont(forTextStyle: .title3))
    private let sunriseLabel = UILabel(text: "05:49", font: .preferredFont(forTextStyle: .title3))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBlue.withAlphaComponent(0.6)
        view.layer.cornerRadius = 6
        setupLabels()
    }
    
    private func setupLabels() {
        let headingsStackView = getHeadingLabelsInStackView()
        let timingsStackView = getTimingsLabelsInStackView()
        
        let stackView = UIStackView(arrangedSubviews: [headingsStackView, timingsStackView])
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.centerInSuperview()
    }
    
    private func getHeadingLabelsInStackView() -> UIStackView {
        [fajrHeadingLabel, sunriseHeadingLabel].forEach({$0.textAlignment = .right})
        let headingsStackView = UIStackView(arrangedSubviews: [fajrHeadingLabel, sunriseHeadingLabel])
        headingsStackView.axis = .vertical
        
        return headingsStackView
    }
    
    private func getTimingsLabelsInStackView() -> UIStackView {
        let timeingsStackView = UIStackView(arrangedSubviews: [fajrLabel, sunriseLabel])
        timeingsStackView.axis = .vertical
        
        return timeingsStackView
    }
    
}
