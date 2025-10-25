//
//  SalahTimes.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/08/2021.
//

import Foundation

public struct SalahTimes: Equatable {
	public let timestamp: String
	public let timezone: String
	public let date: String
	public let fajr: String
	public let sunrise: String
	public let zuhr: String
	public let asr: String
	public let maghrib: String
	public let isha: String

	public init(timestamp: String, timezone: String, date: String, fajr: String, sunrise: String, zuhr: String, asr: String, maghrib: String, isha: String) {
		self.timestamp = timestamp
		self.timezone = timezone
		self.date = date
		self.fajr = fajr
		self.sunrise = sunrise
		self.zuhr = zuhr
		self.asr = asr
		self.maghrib = maghrib
		self.isha = isha
	}
}
