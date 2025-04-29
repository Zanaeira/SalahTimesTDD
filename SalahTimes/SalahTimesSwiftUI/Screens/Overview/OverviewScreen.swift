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
				Text(Date(), format: .dateTime.day().month().year())
					.font(.title)
					.padding(.top, 48)
				ForEach(locationsSettings) {
					LocationCard(loader: loader, locationSettings: $0)
				}
			}
			.padding(.bottom)
		}
		.background(BackgroundView().ignoresSafeArea())
	}

}
