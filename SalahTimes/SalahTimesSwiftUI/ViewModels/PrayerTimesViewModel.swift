//
//  PrayerTimesViewModel.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import Foundation
import SalahTimes

@MainActor
final class PrayerTimesViewModel: ObservableObject {

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
	@Published private(set) var state: State?

	func load(location: Location) async {
		let endpoint = AladhanAPIEndpoint.timingsByAddress(location.location, on: date, iso8601DateFormat: true, madhhabForAsr: location.mithl, fajrIshaMethod: location.calculationAngle)
		state = .loading
		let result = await salahTimesLoader.loadTimes(from: endpoint)

		switch result {
		case .success(let times):
			salahTimes = []
			salahTimes.append(.fajr(time: map(times.fajr)))
			salahTimes.append(.sunrise(time: map(times.sunrise)))
			salahTimes.append(.zuhr(time: map(times.zuhr)))
			salahTimes.append(.asr(time: map(times.asr)))
			salahTimes.append(.maghrib(time: map(times.maghrib)))
			salahTimes.append(.isha(time: map(times.isha)))
			state = .success
		case .failure:
			state = .failure(errorMessage: "Something went wrong. Please try again.")
		}
	}

	private let salahTimesLoader: TimesLoader

	private func map(_ time: String) -> Date {
		guard let salahTime = ISO8601DateFormatter().date(from: time) else { assertionFailure(); return .now }
		return salahTime
	}
}
