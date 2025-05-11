//
//  UpcomingSalahView.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 01/05/2025.
//

import SwiftUI
import SalahTimes

struct UpcomingSalahView: View {

	init(loader: UpcomingSalahLoader, locationSettings: LocationSettings) {
		self.locationSettings = locationSettings
		_viewModel = .init(wrappedValue: UpcomingSalahViewModel(loader: loader))
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
	@StateObject private var viewModel: UpcomingSalahViewModel

	private let secondary = Color.white.opacity(0.8)

	@ViewBuilder
	private var upcomingSalahView: some View {
		VStack(spacing: 2) {
			if let salah = salah(from: viewModel.upcomingSalah), let time = viewModel.upcomingSalahTime {
				image(for: salah)
				Text(time)
				Text(salah.metadata.name)
					.font(.callout.smallCaps())
			}
		}
		.frame(minWidth: 75)
		.fixedSize(horizontal: true, vertical: false)
	}

	private var horizontallyStackedOverview: some View {
		HStack(alignment: .lastTextBaseline) {
			VStack(alignment: .leading, spacing: 0) {
				titleAndSubtitle
				Spacer()
				timeLeft
					.fixedSize(horizontal: true, vertical: false)
			}
			Spacer()
			upcomingSalahView
		}
	}

	private var verticallyStackedOverview: some View {
		HStack {
			VStack(alignment: .leading, spacing: 0) {
				titleAndSubtitle
				if let salah = salah(from: viewModel.upcomingSalah), let time = viewModel.upcomingSalahTime {
					HStack(alignment: .bottom, spacing: 8) {
						image(for: salah)
						Text(salah.metadata.name)
							.font(.callout.smallCaps())
					}
					.fixedSize(horizontal: true, vertical: false)
					Text(time)
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
		if let timeLeft = viewModel.upcomingSalah?.time {
			(Text("Next Salāh in ") + Text(timeLeft, style: .relative))
				.font(.callout.smallCaps())
				.foregroundStyle(.secondary)
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

	private func image(for salah: Salah) -> some View {
		Image(systemName: salah.imageSystemName)
			.font(.largeTitle)
			.symbolVariant(.fill)
			.foregroundStyle(.orange)
	}
}
