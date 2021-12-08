//
//  SalahTimes.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import Foundation

struct SalahTimes: Equatable {
    
    let date: Date
    let fajr: String
    let sunrise: String
    let zuhr: String
    let asr: String
    let maghrib: String
    let isha: String
    
    static var sampleTimes: SalahTimes {
        stubs.randomElement() ?? .init(date: anyDate, fajr: "06:10", sunrise: "07:53", zuhr: "11:52", asr: "14:05", maghrib: "15:52", isha: "17:35")
    }
    
    private static let anyDate = Date()
    private static let stubs: [SalahTimes] = [
        .init(date: anyDate, fajr: "06:10", sunrise: "07:53", zuhr: "11:52", asr: "14:05", maghrib: "15:52", isha: "17:35"),
        .init(date: anyDate, fajr: "06:11", sunrise: "07:54", zuhr: "11:53", asr: "14:05", maghrib: "15:51", isha: "17:35"),
        .init(date: anyDate, fajr: "06:12", sunrise: "07:55", zuhr: "11:53", asr: "14:05", maghrib: "15:51", isha: "17:35"),
        .init(date: anyDate, fajr: "06:13", sunrise: "07:56", zuhr: "11:54", asr: "14:05", maghrib: "15:51", isha: "17:35"),
        .init(date: anyDate, fajr: "06:13", sunrise: "07:57", zuhr: "11:54", asr: "14:05", maghrib: "15:51", isha: "17:35"),
        .init(date: anyDate, fajr: "06:11", sunrise: "07:58", zuhr: "11:55", asr: "14:05", maghrib: "15:51", isha: "17:35"),
        .init(date: anyDate, fajr: "06:14", sunrise: "07:59", zuhr: "11:55", asr: "14:05", maghrib: "15:51", isha: "17:35")
    ]
    
}
