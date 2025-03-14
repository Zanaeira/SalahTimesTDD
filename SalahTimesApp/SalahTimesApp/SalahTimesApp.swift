//
//  SalahTimesApp.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
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
		}
	}

}
