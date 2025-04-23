//
//  PrayerTimesScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
import SalahTimes

public struct LocationsScreen: View {

	public init(loader: TimesLoader) {
		_viewModel = .init(wrappedValue: PrayerTimesViewModel(loader: loader))
	}

	public var body: some View {
		VStack {
			Text(viewModel.date, format: .dateTime.weekday().day().month().year())
		}
		.task {
			await viewModel.load(location: .init(
				location: "London",
				mithl: .hanafi,
				calculationAngle: .custom(methodSettings: .init(fajrAngle: 12, maghribAngle: nil, ishaAngle: 12)))
			)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

	@StateObject private var viewModel: PrayerTimesViewModel

}
