//
//  PrayerTimesScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
import SalahTimes

public struct LocationsScreen: View {

	let locationsSettings: [LocationSettings]

	public init(loader: TimesLoader, locationsSettings: [LocationSettings]) {
		_viewModel = .init(wrappedValue: PrayerTimesViewModel(loader: loader))
		self.locationsSettings = locationsSettings
	}

	public var body: some View {
		VStack {
			Text(viewModel.date, format: .dateTime.weekday().day().month().year())
		}
		.task {
			for locationSettings in locationsSettings {
				await viewModel.load(locationSettings: locationSettings)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

	@StateObject private var viewModel: PrayerTimesViewModel

}
