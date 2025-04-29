//
//  LocationCard.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 26/04/2025.
//

import SwiftUI
import SalahTimes

struct LocationCard: View {

	init(loader: TimesLoader, locationSettings: LocationSettings) {
		self.locationSettings = locationSettings
		_viewModel = .init(wrappedValue: PrayerTimesViewModel(loader: loader))
	}

	var body: some View {
		GroupBox {
			switch viewModel.state {
			case nil, .loading:
				ProgressView()
			case .success:
				SalahTimesView(locationSettings: locationSettings, viewModel: viewModel)
			case .failure(let errorMessage):
				errorView(errorMessage)
			}
		} label: {
			Text(locationSettings.location)
				.font(.title)
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.task { await viewModel.load(locationSettings: locationSettings) }
	}

	@State private var locationSettings: LocationSettings
	@StateObject private var viewModel: PrayerTimesViewModel

	private func errorView(_ errorMessage: String) -> some View {
		VStack(spacing: 4) {
			Text(errorMessage)
				.font(.callout)
				.foregroundStyle(.red)
			Button {
				Task { await viewModel.load(locationSettings: locationSettings) }
			} label: {
				Image(systemName: "arrow.clockwise")
					.frame(minWidth: 36, minHeight: 36)
			}
		}
		.fontWeight(.semibold)
	}

}
