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
        setupCollectionViewController()
    }
    
    private func setupCollectionViewController() {
        add(overviewCollectionViewController)
        
        overviewCollectionViewController.view.fillSuperview()
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

