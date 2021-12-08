//
//  SalahTimesViewController.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import UIKit

final class SalahTimesViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let salahTimesLoader: SalahTimesLoader
    
    init(salahTimesLoader: SalahTimesLoader) {
        self.salahTimesLoader = salahTimesLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemTeal
    }
    
}
