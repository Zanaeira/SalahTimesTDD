//
//  LocationSummary.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 10/05/2025.
//

import SwiftUI
import SalahTimes

struct LocationSummary: View {

	init(loader: TimesLoader, locationSettings: LocationSettings) {
		self.locationSettings = locationSettings
		_viewModel = .init(wrappedValue: LocationSummaryViewModel(loader: loader))
	}

	var body: some View {
		GroupBox {
			if !dynamicTypeSize.isAccessibilitySize {
				horizontallyStackedOverview
			} else {
				verticallyStackedOverview
			}
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.task { await viewModel.load(locationSettings: locationSettings) }
	}

	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	@State private var locationSettings: LocationSettings
	@StateObject private var viewModel: LocationSummaryViewModel

	private let secondary = Color.white.opacity(0.8)

	@ViewBuilder
	private var currentSalahView: some View {
		VStack(spacing: 2) {
			if let salah = viewModel.currentSalah {
				image(for: salah)
				Text(viewModel.formatter.string(from: salah.time))
				Text(salah.metadata.name)
					.font(.callout.smallCaps())
			}
		}
		.frame(minWidth: 75)
		.fixedSize(horizontal: true, vertical: false)
	}

	private var horizontallyStackedOverview: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 0) {
				titleAndSubtitle
				Spacer()
				timeLeft
					.fixedSize(horizontal: true, vertical: false)
			}
			Spacer()
			currentSalahView
		}
	}

	private var verticallyStackedOverview: some View {
		HStack {
			VStack(alignment: .leading, spacing: 0) {
				titleAndSubtitle
				if let salah = viewModel.currentSalah {
					HStack(alignment: .bottom, spacing: 8) {
						image(for: salah)
						Text(salah.metadata.name)
							.font(.callout.smallCaps())
					}
					.fixedSize(horizontal: true, vertical: false)
					Text(viewModel.formatter.string(from: salah.time))
				}
				timeLeft
			}
			Spacer()
		}
	}

	@ViewBuilder
	private var titleAndSubtitle: some View {
		Text(locationSettings.location)
			.font(.title)
		viewModel.currentDateAndTime.map(Text.init)
			.font(.subheadline)
			.foregroundStyle(.secondary)
	}

	@ViewBuilder
	private var timeLeft: some View {
		if let salah = viewModel.currentSalah, let timeRemaining = viewModel.timeRanges[salah] {
			ProgressView(timerInterval: timeRemaining, countsDown: true) {
				Text("Time remaining for \(salah.metadata.name)")
					.font(.callout.smallCaps())
					.foregroundStyle(.secondary)
			}
		}
	}

	private func image(for salah: Salah) -> some View {
		Image(systemName: salah.imageSystemName)
			.font(.largeTitle)
			.symbolVariant(.fill)
			.foregroundStyle(.orange)
	}
}
