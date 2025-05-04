//
//  UpcomingSalahViewModel.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import Foundation
import SalahTimes

@MainActor
final class UpcomingSalahViewModel: ObservableObject {

	init(loader: UpcomingSalahLoader) {
		self.loader = loader
	}

	@Published private(set) var upcomingSalah: UpcomingSalah?
	@Published private(set) var date = Date()

	var currentDateAndTime: String? {
		guard let upcomingSalah, let timeZone = TimeZone(identifier: upcomingSalah.timezone) else { return nil }
		let formatter = DateFormatter.salahDateAndTimeFormatter
		formatter.timeZone = timeZone
		return formatter.string(from: .now)
	}

	var upcomingSalahTime: String? {
		guard let upcomingSalah, let timeZone = TimeZone(identifier: upcomingSalah.timezone) else { return nil }
		let formatter = DateFormatter.salahTimeOnlyFormatter
		formatter.timeZone = timeZone
		return formatter.string(from: upcomingSalah.time)
	}

	func load(locationSettings: LocationSettings) async {
		let endpoint = AladhanAPIEndpoint.nextPrayerByAddress(locationSettings.location, on: date, madhhab: locationSettings.mithl, fajrIsha: locationSettings.calculationAngle)
		let result = await loader.load(from: endpoint)

		switch result {
		case .success(let upcomingSalah):
			self.upcomingSalah = upcomingSalah
		case .failure:
			break
		}
	}

	private let loader: UpcomingSalahLoader

}

fileprivate extension DateFormatter {
	static let salahDateAndTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short

		return formatter
	}()
	static let salahTimeOnlyFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short

		return formatter
	}()

}
