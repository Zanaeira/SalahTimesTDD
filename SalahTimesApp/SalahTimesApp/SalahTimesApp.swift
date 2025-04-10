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
				PrayerTimesScreen()
					.tabItem { Label("Today", systemImage: "clock") }

				CalendarScreen()
					.tabItem { Label("Calendar", systemImage: "calendar") }
			}
			.onAppear { registerDefaults() }
		}
	}

	private func registerDefaults() {
		let suiteDefaults = UserDefaults.standard
		suiteDefaults.register(defaults: [
			"suiteNames": ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
		])

		let suiteNames = suiteDefaults.stringArray(forKey: "suiteNames") ?? ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
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
