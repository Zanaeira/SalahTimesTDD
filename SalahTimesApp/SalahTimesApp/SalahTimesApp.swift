//
//  SalahTimesApp.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
import SalahTimes
import SalahTimesSwiftUI

@main
struct SalahTimesApp: App {

	var body: some Scene {
		WindowGroup {
			TabView {
				OverviewScreen(loader: compositeTimesLoader, locationsSettings: locationSettings)
					.tabItem { Label("Overview", systemImage: "calendar") }

				LocationsScreen(loader: compositeTimesLoader, locationsSettings: locationSettings)
					.tabItem { Label("Locations", systemImage: "location") }
			}
			.onAppear { registerDefaults() }
		}
	}

	private let userDefaults = UserDefaults.standard
	private var compositeTimesLoader = SalahTimesLoaderWithFallbackComposite(primaryLoader: Self.makePrimaryLoader(), fallbackLoader: Self.makeFallbackLoader())

	private var suiteNames: [String] { userDefaults.stringArray(forKey: "suiteNames") ?? ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"] }
	private var locationSettings: [LocationSettings] {
		suiteNames.compactMap { suiteName in
			guard let defaults = UserDefaults(suiteName: suiteName), let location = defaults.string(forKey: "Location") else {
				return nil
			}

			let mithl = AladhanAPIEndpoint.Madhhab(rawValue: defaults.integer(forKey: "Mithl")) ?? .hanafi
			guard let fajrIshaMethod = defaults.object(forKey: "FajrIsha") as? Data, let angleCalculationMethod: AladhanAPIEndpoint.Method = try? JSONDecoder().decode(AladhanAPIEndpoint.Method.self, from: fajrIshaMethod) else {
				return .init(userDefaults: defaults, location: location, mithl: mithl, calculationAngle: .custom(methodSettings: .init(fajrAngle: 12, maghribAngle: nil, ishaAngle: 12)))
			}

			return .init(userDefaults: defaults, location: location, mithl: mithl, calculationAngle: angleCalculationMethod)
		}
	}

	private func registerDefaults() {
		let suiteDefaults = UserDefaults.standard
		suiteDefaults.register(defaults: [
			"suiteNames": ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
		])

		for suiteName in suiteNames {
			if let defaults = UserDefaults(suiteName: suiteName) {
				registerSalahTimes(defaults, forDefaultLocation: "London")
			}
		}
	}

	private func registerSalahTimes(_ suite: UserDefaults, forDefaultLocation location: String) {
		suite.register(defaults: [
			"Mithl": 2,
			"Location": location
		])

		if let fajrIshaMethod = getEncodedFajrIshaMethod() {
			suite.register(defaults: [
				"FajrIsha": fajrIshaMethod
			])
		}
	}

	private func getEncodedFajrIshaMethod() -> Data? {
		try? JSONEncoder().encode(AladhanAPIEndpoint.Method.custom(methodSettings: .init(fajrAngle: 12.0, maghribAngle: nil, ishaAngle: 12.0)))
	}

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
