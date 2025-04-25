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
	let locations: [Location]

	public init(loader: TimesLoader, locations: [Location]) {
		self.loader = loader
		self.locations = locations
	}

	public var body: some View {
		ScrollView {
			VStack (spacing: 16) {
				Text(Date(), format: .dateTime.day().month().year())
					.font(.title)
					.padding(.top, 48)
				ForEach(locations) {
					LocationCard(loader: loader, location: $0)
				}
			}
			.padding(.bottom)
		}
		.background(BackgroundView().ignoresSafeArea())
	}

}
