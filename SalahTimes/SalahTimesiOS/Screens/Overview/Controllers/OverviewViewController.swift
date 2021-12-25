//
//  OverviewViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 22/12/2021.
//

import UIKit
import SalahTimes

public final class OverviewViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private var date = Date()
    
    private let dateLabel = UILabel()
    private let overviewCollectionViewController: OverviewCollectionViewController
    
    public init(client: HTTPClient, userDefaults: UserDefaults) {
        overviewCollectionViewController = OverviewCollectionViewController(client: client, userDefaults: userDefaults)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundGradient.frame = view.bounds
    }
    
    private func configureUI() {
        setupBackground()
        setupDateLabel()
        ensureDateStaysUpToDate()
        setupCollectionViewController()
    }
    
    private func setupDateLabel() {
        updateDateLabelText(date: date)
        dateLabel.font = .preferredFont(forTextStyle: .title1)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.textAlignment = .center
        
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(dateLabel)
        dateLabel.centerXInSuperview()
        dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    }
    
    private func updateDateLabelText(date: Date) {
        let dateString = DateFormatter.presentableDateFormatter.string(from: date)
        dateLabel.text = dateString
    }
    
    private func ensureDateStaysUpToDate() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDateToMatchSystemDate), name: .NSCalendarDayChanged, object: nil)
    }
    
    @objc private func updateDateToMatchSystemDate() {
        DispatchQueue.main.async {
            self.updateDateLabelText(date: Date())
            self.overviewCollectionViewController.refresh()
        }
    }
    
    private func setupCollectionViewController() {
        add(overviewCollectionViewController)
        
        let safeArea = view.safeAreaLayoutGuide
        overviewCollectionViewController.view.anchor(top: dateLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    private let backgroundGradient = CAGradientLayer()
    
    private func setupBackground() {
        let purple = UIColor(red: 0.45, green: 0.40, blue: 1.00, alpha: 1.00).cgColor
        let blue = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
        
        backgroundGradient.type = .axial
        backgroundGradient.colors = [blue, purple]
        backgroundGradient.startPoint = .init(x: 0, y: 0)
        backgroundGradient.endPoint = .init(x: 0.25, y: 1)
        
        backgroundGradient.frame = view.bounds
        view.layer.addSublayer(backgroundGradient)
    }
    
}

private extension DateFormatter {
    
    static let presentableDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
}
