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
				salahTimesView
			case .failure(let errorMessage):
				errorView(errorMessage)
			}
		} label: {
			Text(locationSettings.location)
				.font(.title)
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.onChange(of: locationSettings) { Task { await viewModel.load(locationSettings: locationSettings) } }
		.onChange(of: scenePhase) {
			guard scenePhase == .active else { return }
			animateMenu.toggle()
		}
		.task { await viewModel.load(locationSettings: locationSettings) }
	}

	@State private var locationSettings: LocationSettings
	@StateObject private var viewModel: PrayerTimesViewModel
	@Environment(\.dynamicTypeSize) private var dynamicTypeSize
	@Environment(\.scenePhase) private var scenePhase
	@State private var animateMenu = false

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

	private func row(_ salahs: [Salah]) -> some View {
		ForEach(salahs, id: \.metadata.name) { salah in
			if case .fajr = salah {
				Menu {
					Button("12º") { locationSettings.fajrAngle = 12 }
					Button("15º") { locationSettings.fajrAngle = 15 }
					Button("18º") { locationSettings.fajrAngle = 18 }
				} label: {
					salahView(salah)
						.symbolEffect(.bounce.byLayer, value: animateMenu)
						.tint(.white)
				}
			} else if case .asr = salah {
				Menu {
					Button("First mithl") { locationSettings.mithl = .shafii }
					Button("Second mithl") { locationSettings.mithl = .hanafi }
				} label: {
					salahView(salah)
						.symbolEffect(.bounce.byLayer, value: animateMenu)
						.tint(.white)
				}
			} else {
				salahView(salah)
			}
		}
	}

	private func salahView(_ salah: Salah) -> some View {
		VStack(spacing: 4) {
			salah.image
				.font(.title2)
				.frame(minWidth: 24, minHeight: 24)
				.padding(.bottom, 2)
				.foregroundStyle(.orange)
			Text(salah.metadata.name)
			Text(viewModel.formatter.string(from: salah.time))
		}
		.fixedSize(horizontal: true, vertical: false)
	}

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
