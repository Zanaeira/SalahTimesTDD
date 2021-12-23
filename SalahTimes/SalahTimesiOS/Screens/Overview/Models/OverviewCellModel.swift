//
//  OverviewCellModel.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 22/12/2021.
//

import Foundation
import SalahTimes

struct OverviewCellModel: Hashable {
    
    private let id = UUID()
    
    let location: String
    let fajr: SalahTimesCellModel
    let sunrise: SalahTimesCellModel
    let zuhr: SalahTimesCellModel
    let asr: SalahTimesCellModel
    let maghrib: SalahTimesCellModel
    let isha: SalahTimesCellModel
    
    var times: [SalahTimesCellModel] {
        [fajr, sunrise, zuhr, asr, maghrib, isha]
    }
    
    init(location: String, salahTimes: SalahTimes) {
        self.location = location
        fajr = .init(name: "Fajr", time: salahTimes.fajr, imageName: "sun.haze.fill")
        sunrise = .init(name: "Sunrise", time: salahTimes.sunrise, imageName: "sunrise.fill")
        zuhr = .init(name: "Zuhr", time: salahTimes.zuhr, imageName: "sun.max.fill")
        asr = .init(name: "Asr", time: salahTimes.asr, imageName: "sun.min.fill")
        maghrib = .init(name: "Maghrib", time: salahTimes.maghrib, imageName: "sunset.fill")
        isha = .init(name: "Isha", time: salahTimes.isha, imageName: "moon.stars.fill")
    }
    
}
