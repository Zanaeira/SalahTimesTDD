//
//  LocationSummaryViewModel.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 10/05/2025.
//

import Foundation
import SalahTimes

@MainActor
final class LocationSummaryViewModel: ObservableObject {

	init(loader: TimesLoader) {
		salahTimesLoader = loader
	}

	enum State {
		case loading
		case success
		case failure(errorMessage: String)
	}

	@Published private(set) var date = Date()
	@Published private(set) var salahTimes = [Salah]()
	@Published private(set) var currentSalah: Salah?
	@Published private(set) var state: State?
	private(set) var timeZone: String = "London/Europe"

	var currentDateAndTime: String? {
		let timeZone = TimeZone(identifier: timeZone)
		let formatter = DateFormatter.salahDateAndTimeFormatter
		formatter.timeZone = timeZone
		return formatter.string(from: .now)
	}

	var formatter: DateFormatter {
		let dateFormatter = DateFormatter.salahTimesFormatter
		dateFormatter.timeZone = .init(identifier: timeZone)
		return dateFormatter
	}

	func load(locationSettings: LocationSettings) async {
		let endpoint = AladhanAPIEndpoint.timingsByAddress(locationSettings.location, on: date, iso8601DateFormat: true, madhhabForAsr: locationSettings.mithl, fajrIshaMethod: locationSettings.calculationAngle)
		state = .loading
		let result = await salahTimesLoader.load(from: endpoint)

		switch result {
		case .success(let times):
			timeZone = times.timezone
			mapSalahTimes(from: times)
			setCurrentSalah(using: times)
			state = .success
		case .failure:
			state = .failure(errorMessage: "Something went wrong. Please try again.")
		}
	}

	func timeRemaining(for salah: Salah) -> Date? {
		timeRanges[salah]?.upperBound
	}

	private let salahTimesLoader: TimesLoader
	private(set) var timeRanges: [Salah: ClosedRange<Date>] = [:]

	private func mapSalahTimes(from times: SalahTimes) {
		salahTimes = []
		salahTimes.append(.fajr(time: map(times.fajr)))
		salahTimes.append(.sunrise(time: map(times.sunrise)))
		salahTimes.append(.zuhr(time: map(times.zuhr)))
		salahTimes.append(.asr(time: map(times.asr)))
		salahTimes.append(.maghrib(time: map(times.maghrib)))
		salahTimes.append(.isha(time: map(times.isha)))
	}

	private func map(_ time: String) -> Date {
		guard let salahTime = ISO8601DateFormatter().date(from: time) else { assertionFailure(); return .now }
		return salahTime
	}

	private func setCurrentSalah(using times: SalahTimes) {
		timeRanges = [
			Salah.fajr(time: map(times.fajr)): map(times.fajr)...map(times.sunrise),
			Salah.sunrise(time: map(times.sunrise)): map(times.sunrise)...map(times.zuhr),
			Salah.zuhr(time: map(times.zuhr)): map(times.zuhr)...map(times.asr),
			Salah.asr(time: map(times.asr)): map(times.asr)...map(times.maghrib),
			Salah.maghrib(time: map(times.maghrib)): map(times.maghrib)...map(times.isha)
		]
		currentSalah = timeRanges.first(where: { (_, timeRange) in timeRange.contains(.now) })?.key ?? .isha(time: map(times.isha))
	}

}

fileprivate extension DateFormatter {
	static let salahDateAndTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short

		return formatter
	}()
	static let salahTimesFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short

		return formatter
	}()
}
