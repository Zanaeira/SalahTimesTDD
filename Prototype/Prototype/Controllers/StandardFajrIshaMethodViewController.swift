//
//  StandardFajrIshaMethodViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 07/08/2021.
//

import UIKit

final class StandardFajrIshaMethodViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let methodsPickerViewDataSourceDelegate = FajrIshaMethodPickerViewDataSourceDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = methodsPickerViewDataSourceDelegate
        pickerView.delegate = methodsPickerViewDataSourceDelegate
    }
    
}

private final class FajrIshaMethodPickerViewDataSourceDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let data = [
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
