//
//  LocationSummary.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 01/05/2025.
//

import SwiftUI
import SalahTimes

struct LocationSummary: View {

	init(loader: UpcomingSalahLoader, locationSettings: LocationSettings) {
		self.locationSettings = locationSettings
		_viewModel = .init(wrappedValue: UpcomingSalahViewModel(loader: loader))
	}

	var body: some View {
		GroupBox {
			HStack(alignment: .lastTextBaseline) {
				VStack(alignment: .leading, spacing: 16) {
					Text(locationSettings.location)
						.font(.title)
					Spacer()
					if let timeLeft = viewModel.upcomingSalah?.time.formatted(.relative(presentation: .numeric, unitsStyle: .narrow)) {
						Text("Next Salāh \(timeLeft)")
							.font(.callout.smallCaps())
							.foregroundStyle(.secondary)
					}
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
	@StateObject private var viewModel: UpcomingSalahViewModel

	private let secondary = Color.white.opacity(0.8)

	@ViewBuilder
	private var upcomingSalahView: some View {
		VStack(spacing: 2) {
			if let salah = salah(from: viewModel.upcomingSalah) {
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

	private func salah(from upcomingSalah: UpcomingSalah?) -> Salah? {
		guard let upcomingSalah else { return nil }
		return switch upcomingSalah.name {
		case "Fajr": .fajr(time: upcomingSalah.time)
		case "Zuhr": .zuhr(time: upcomingSalah.time)
		case "Asr": .asr(time: upcomingSalah.time)
		case "Maghrib": .maghrib(time: upcomingSalah.time)
		case "Isha": .isha(time: upcomingSalah.time)
		default: nil
		}
	}
}
