//
//  SalahTimes.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/08/2021.
//

import Foundation

public struct SalahTimes: Equatable {
    public let date: Date?
    public let fajr: String
    public let sunrise: String
    public let zuhr: String
    public let asr: String
    public let maghrib: String
    public let isha: String
}
