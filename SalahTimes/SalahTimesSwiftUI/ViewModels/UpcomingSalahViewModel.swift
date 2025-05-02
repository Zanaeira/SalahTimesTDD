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

	var formatter: DateFormatter {
		let dateFormatter = DateFormatter.salahTimesFormatter
		dateFormatter.timeZone = .init(identifier: timeZone)
		return dateFormatter
	}

	func load(locationSettings: LocationSettings) async {
		let endpoint = AladhanAPIEndpoint.nextPrayerByAddress(locationSettings.location, on: date, iso8601DateFormat: true, madhhab: locationSettings.mithl, fajrIsha: locationSettings.calculationAngle)
		let result = await loader.load(from: endpoint)

		switch result {
		case .success(let upcomingSalah):
			timeZone = upcomingSalah.timezone
			self.upcomingSalah = upcomingSalah
			print(timeZone)
			print(upcomingSalah)
		case .failure:
			break
		}
	}

	private let loader: UpcomingSalahLoader

}

fileprivate extension DateFormatter {
	static let salahTimesFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short

		return formatter
	}()
}
