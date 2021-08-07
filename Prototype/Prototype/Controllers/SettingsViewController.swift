//
//  SettingsViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 07/08/2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fajrIshaMethodPickerView: UIPickerView!
    
    private let pickerViewDataSourceDelegate = FajrIshaMethodPickerViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fajrIshaMethodPickerView.dataSource = pickerViewDataSourceDelegate
        fajrIshaMethodPickerView.delegate = pickerViewDataSourceDelegate
    }
    
}

private final class FajrIshaMethodPickerViewDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let data = [
        "Shia Ithna Ansari",
        "University Of Islamic Sciences Karachi",
        "Islamic Society Of North America",
        "Muslim World League",
        "Umm Al-Qura University Makkah",
        "Egyptian General Authority Of Survey",
        "Institute Of Geophysics University Of Tehran",
        "Gulf Region",
        "Kuwait",
        "Qatar",
        "Majlis Ugama Islam Singapura Singapore",
        "Union Organization Islamic De France",
        "Diyanet İşleri Başkanlığı Turkey",
        "Spiritual Administration Of Muslims Of Russia"
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
}
