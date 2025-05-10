//
//  CalendarScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import SwiftUI
import SalahTimes

public struct OverviewScreen: View {

	let loader: UpcomingSalahLoader
	let locationsSettings: [LocationSettings]

	public init(loader: UpcomingSalahLoader, locationsSettings: [LocationSettings]) {
		self.loader = loader
		self.locationsSettings = locationsSettings
	}

	public var body: some View {
		ScrollView {
			VStack (spacing: 16) {
				ForEach(locationsSettings) {
					UpcomingSalahView(loader: loader, locationSettings: $0)
				}
			}
			.padding(.vertical)
		}
		.background(BackgroundView().ignoresSafeArea())
	}

}
