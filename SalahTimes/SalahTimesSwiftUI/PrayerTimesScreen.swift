//
//  PrayerTimesScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
import SalahTimes

public struct PrayerTimesScreen: View {

	public init() {}

	public var body: some View {
		VStack {
			Text(viewModel.date, format: .dateTime.weekday().day().month().year())
			Text(viewModel.label)
		}
		.task { await viewModel.load() }
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(background)
		.ignoresSafeArea()
	}

	private var background: some View {
		let purple = Color(red: 0.45, green: 0.4, blue: 1.0)
		let blue = Color.blue.opacity(0.4)
		return LinearGradient(colors: [blue, purple], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0.25, y: 1))
	}

	@StateObject private var viewModel: PrayerTimesViewModel = .init()

}

@MainActor
class PrayerTimesViewModel: ObservableObject {

	init() {
		salahTimesLoader = SalahTimesLoaderWithFallbackComposite(primaryLoader: Self.makePrimaryLoader(), fallbackLoader: Self.makeFallbackLoader())
	}

	@Published var date = Date()
	@Published var label = ""

	func load() async {
		let endpoint = AladhanAPIEndpoint.timingsByAddress("London", on: .now)
		let result = await salahTimesLoader.loadTimes(from: endpoint)

		switch result {
		case .success(let times):
			self.label = "Fajr: \(times.fajr)\n"
			self.label += "Sunrise: \(times.sunrise)\n"
			self.label += "Zuhr: \(times.zuhr)\n"
			self.label += "Asr: \(times.asr)\n"
			self.label += "Maghrib: \(times.maghrib)\n"
			self.label += "Isha: \(times.isha)\n"
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
