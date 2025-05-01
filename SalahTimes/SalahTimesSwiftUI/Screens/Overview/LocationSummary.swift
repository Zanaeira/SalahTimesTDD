//
//  LocationSummary.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 01/05/2025.
//

import SwiftUI
import SalahTimes

struct LocationSummary: View {

	init(loader: TimesLoader, locationSettings: LocationSettings) {
		self.locationSettings = locationSettings
		_viewModel = .init(wrappedValue: PrayerTimesViewModel(loader: loader))
	}

	var body: some View {
		GroupBox {
			HStack(alignment: .lastTextBaseline) {
				VStack(alignment: .leading, spacing: 16) {
					Text(locationSettings.location)
						.font(.title)
					Spacer()
					let timeLeft = Date().formatted(.relative(presentation: .numeric, unitsStyle: .narrow))
					Text("Next Salāh \(timeLeft)")
						.font(.callout.smallCaps())
						.foregroundStyle(.secondary)
				}
				Spacer()
				upcomingSalahView
			}
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.task { await viewModel.load(locationSettings: locationSettings) }
	}

	@State private var locationSettings: LocationSettings
	@StateObject private var viewModel: PrayerTimesViewModel

	private let secondary = Color.white.opacity(0.8)

	@ViewBuilder
	private var upcomingSalahView: some View {
		VStack(spacing: 2) {
			if let salah = viewModel.salahTimes.first {
				Image(systemName: salah.imageSystemName)
					.font(.largeTitle)
					.symbolVariant(.fill)
					.foregroundStyle(.orange)
				Text(viewModel.formatter.string(from: salah.time))
				Text(salah.metadata.name)
					.font(.callout.smallCaps())
					.foregroundStyle(.secondary)
			}
		}
	}
}
