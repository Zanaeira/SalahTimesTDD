//
//  SettingsViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 07/08/2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fajrIshaMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var standardFajrIshaMethodView: UIView!
    @IBOutlet weak var customFajrIshaMethodView: UIView!
    @IBOutlet weak var fajrIshaMethodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchFajrIshaMethod(fajrIshaMethodSegmentedControl)
    }
    
    @IBAction func switchFajrIshaMethod(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            customFajrIshaMethodView.alpha = 0
            standardFajrIshaMethodView.alpha = 1
        } else {
            standardFajrIshaMethodView.alpha = 0
            customFajrIshaMethodView.alpha = 1
        }
    }
}
