//
//  CalendarScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import SwiftUI
import SalahTimes

public struct OverviewScreen: View {

	let loader: TimesLoader
	let locationsSettings: [LocationSettings]

	public init(loader: TimesLoader, locationsSettings: [LocationSettings]) {
		self.loader = loader
		self.locationsSettings = locationsSettings
	}

	public var body: some View {
		ScrollView {
			VStack (spacing: 16) {
				ForEach(locationsSettings) {
					LocationSummary(loader: loader, locationSettings: $0)
				}
			}
			.padding(.vertical)
		}
		.background(BackgroundView().ignoresSafeArea())
	}

}
