//
//  LocationCard.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 26/04/2025.
//

import SwiftUI
import SalahTimes

struct LocationCard: View {

	init(loader: TimesLoader, location: Location) {
		self.location = location
		_viewModel = .init(wrappedValue: PrayerTimesViewModel(loader: loader))
	}

	var body: some View {
		GroupBox {
			switch viewModel.state {
			case nil, .loading:
				ProgressView()
			case .success:
				salahTimesView
			case .failure(let errorMessage):
				errorView(errorMessage)
			}
		} label: {
			Text(location.location)
				.font(.title)
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.onChange(of: location) { Task { await viewModel.load(location: location) } }
		.task { await viewModel.load(location: location) }
	}

	@State private var location: Location
	@StateObject private var viewModel: PrayerTimesViewModel
	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	@ViewBuilder
	private var salahTimesView: some View {
		if dynamicTypeSize.isAccessibilitySize {
			VStack {
				HStack { row(Array(viewModel.salahTimes.prefix(3))) }
				HStack { row(Array(viewModel.salahTimes.dropFirst(3))) }
			}
		} else {
			HStack { row(viewModel.salahTimes) }
		}
	}

	private func row(_ salahTimes: [SalahTime]) -> some View {
		ForEach(salahTimes, id: \.metadata.name) { salah in
			if case .asr = salah {
				Menu {
					Button("First mithl") { location.mithl = .shafii }
					Button("Second mithl") { location.mithl = .hanafi }
				} label: {
					salahView(salah)
						.tint(.white)
				}
			} else {
				salahView(salah)
			}
		}
	}

	private func salahView(_ salahTime: SalahTime) -> some View {
		VStack(spacing: 4) {
			salahTime.image
				.frame(minWidth: 24, minHeight: 24)
				.padding(.bottom, 2)
				.foregroundStyle(.orange)
			Text(salahTime.metadata.name)
			Text(salahTime.time, format: .dateTime.hour().minute())
		}
		.fixedSize(horizontal: true, vertical: false)
	}

	private func errorView(_ errorMessage: String) -> some View {
		VStack(spacing: 4) {
			Text(errorMessage)
				.font(.callout)
				.foregroundStyle(.red)
			Button {
				Task { await viewModel.load(location: location) }
			} label: {
				Image(systemName: "arrow.clockwise")
					.frame(minWidth: 36, minHeight: 36)
			}
		}
		.fontWeight(.semibold)
	}

}
