//
//  PrayerTimesScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
import SalahTimes

public struct LocationsScreen: View {

	let locations: [Location]

	public init(loader: TimesLoader, locations: [Location]) {
		_viewModel = .init(wrappedValue: PrayerTimesViewModel(loader: loader))
		self.locations = locations
	}

	public var body: some View {
		VStack {
			Text(viewModel.date, format: .dateTime.weekday().day().month().year())
		}
		.task {
			for location in locations {
				await viewModel.load(location: location)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

	@StateObject private var viewModel: PrayerTimesViewModel

}
