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

	private(set) var timeZone: String = "London/Europe"

	var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter.salahDateFormatter
		dateFormatter.timeZone = .init(identifier: timeZone)
		return dateFormatter
	}

	var timeFormatter: DateFormatter {
		let dateFormatter = DateFormatter.salahTimesFormatter
		dateFormatter.timeZone = .init(identifier: timeZone)
		return dateFormatter
	}

	func load(locationSettings: LocationSettings) async {
		let endpoint = AladhanAPIEndpoint.nextPrayerByAddress(locationSettings.location, on: date, madhhab: locationSettings.mithl, fajrIsha: locationSettings.calculationAngle)
		let result = await loader.load(from: endpoint)

		switch result {
		case .success(let upcomingSalah):
			timeZone = upcomingSalah.timezone
			self.upcomingSalah = upcomingSalah
		case .failure:
			break
		}
	}

	private let loader: UpcomingSalahLoader

}

fileprivate extension DateFormatter {
	static let salahDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none

		return formatter
	}()
	static let salahTimesFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short

		return formatter
	}()
}
