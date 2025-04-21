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

	init() {
		salahTimesLoader = SalahTimesLoaderWithFallbackComposite(primaryLoader: Self.makePrimaryLoader(), fallbackLoader: Self.makeFallbackLoader())
	}

	@Published var location: String = ""
	@Published var date = Date()
	@Published var salahTimes = [SalahTime]()

	var showLoading: Bool { location.isEmpty }

	func load(location: Location) async {
		let endpoint = AladhanAPIEndpoint.timingsByAddress(location.location, on: date, madhhabForAsr: location.mithl, fajrIshaMethod: location.calculationAngle)
		let result = await salahTimesLoader.loadTimes(from: endpoint)

		switch result {
		case .success(let times):
			self.location = location.location
			salahTimes = []
			salahTimes.append(.fajr(time: times.fajr))
			salahTimes.append(.sunrise(time: times.sunrise))
			salahTimes.append(.zuhr(time: times.zuhr))
			salahTimes.append(.asr(time: times.asr))
			salahTimes.append(.maghrib(time: times.maghrib))
			salahTimes.append(.isha(time: times.isha))
		case .failure: break
		}
	}

	private let salahTimesLoader: TimesLoader

	private static func makePrimaryLoader() -> TimesLoader {
		return SalahTimesLoader(client: makeHTTPClient(withRequestCachePolicy: .reloadRevalidatingCacheData))
	}

	private static func makeFallbackLoader() -> TimesLoader {
		return SalahTimesLoader(client: makeHTTPClient(withRequestCachePolicy: .returnCacheDataElseLoad))
	}

	private static func makeHTTPClient(withRequestCachePolicy policy: NSURLRequest.CachePolicy) -> HTTPClient {
		let config = URLSessionConfiguration.default
		config.urlCache = makeCache()
		config.requestCachePolicy = policy

		let session = URLSession(configuration: config)

		return URLSessionHTTPClient(session: session)
	}

	private static func makeCache() -> URLCache {
		let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")

		return URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, directory: diskCacheURL)
	}

}
