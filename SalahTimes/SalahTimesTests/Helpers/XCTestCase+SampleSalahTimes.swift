//
//  XCTestCase+SampleSalahTimes.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import XCTest
@testable import SalahTimes

extension XCTestCase {
    
    func salahTimesModelAndDataFor5thAug2021LondonUK() -> (model: SalahTimes, data: Data) {
        let timestamp: Double = 1628118000
        
        let (salahTimes, salahTimesJSON) = makeSalahTimes(
            fajr: "03:27", sunrise: "05:31", zuhr: "13:07", asr: "17:14",
            sunset: "20:42", maghrib: "20:42", isha: "22:44", imsak: "03:17",
            midnight: "01:06", readableDate: "05 Aug 2021", timestamp: timestamp)
        
        let data = makeSalahTimesJSON(salahTimesJSON)
        
        return (salahTimes, data)
    }
    
    private func makeSalahTimes(fajr: String, sunrise: String, zuhr: String, asr: String, sunset: String, maghrib: String, isha: String, imsak: String, midnight: String, readableDate: String, timestamp: Double) -> (model: SalahTimes, json: [String: [String: String]]) {
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        let salahTimesModel = SalahTimes(date: date, fajr: fajr, sunrise: sunrise, zuhr: zuhr, asr: asr, maghrib: maghrib, isha: isha)
        
        let salahTimesJSON = [
            "timings": [
                "Fajr": fajr,
                "Sunrise": sunrise,
                "Dhuhr": zuhr,
                "Asr": asr,
                "Sunset": sunset,
                "Maghrib": maghrib,
                "Isha": isha,
                "Imsak": imsak,
                "Midnight": midnight,
            ],
            "date": [
                "readable": readableDate,
                "timestamp": "\(timestamp)",
            ]
        ]
        
        return (salahTimesModel, salahTimesJSON)
    }
    
    private func makeSalahTimesJSON(_ timings: [String: [String: String]]) -> Data {
        let json = ["data": timings]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    
}
