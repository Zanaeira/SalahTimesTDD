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
			NavigationStack {
				OverviewScreen(loader: SalahTimesLoaderComposer().loader, locationsSettings: locationSettings)
					.navigationTitle("My locations")
					.onAppear { registerDefaults() }
			}
		}
	}

	private let userDefaults = UserDefaults.standard

	private var suiteNames: [String] { userDefaults.stringArray(forKey: "suiteNames") ?? ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"] }
	private var locationSettings: [LocationSettings] {
		suiteNames.compactMap { suiteName in
			guard let defaults = UserDefaults(suiteName: suiteName), let location = defaults.string(forKey: "Location") else {
				return nil
			}

			let mithl = AladhanAPIEndpoint.Madhhab(rawValue: defaults.integer(forKey: "Mithl")) ?? .hanafi
			let calculationMethod: AladhanAPIEndpoint.Method
			if let methodData = defaults.object(forKey: "FajrIsha") as? Data,
				 let fajrIshaMethod = try? JSONDecoder().decode(AladhanAPIEndpoint.Method.self, from: methodData) {
				calculationMethod = fajrIshaMethod
			} else {
				calculationMethod = .custom(methodSettings: .init(fajrAngle: 12, maghribAngle: nil, ishaAngle: 12))
			}

			return .init(userDefaults: defaults, location: location, mithl: mithl, calculationAngle: calculationMethod)
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

}
