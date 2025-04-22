//
//  CalendarScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import SwiftUI
import SalahTimes

public struct OverviewScreen: View {

	let locations: [Location]

	public init(locations: [Location]) {
		self.locations = locations
	}

	public var body: some View {
		ScrollView {
			VStack (spacing: 16) {
				Text(Date(), format: .dateTime.day().month().year())
					.font(.title)
					.padding(.top, 48)
				ForEach(locations) {
					SalahTimesOverview(location: $0)
				}
			}
			.padding(.bottom)
		}
		.background(BackgroundView().ignoresSafeArea())
	}

}

fileprivate struct SalahTimesOverview: View {

	let location: Location

	var body: some View {
		GroupBox {
				if dynamicTypeSize.isAccessibilitySize {
					VStack {
						HStack { ForEach(viewModel.salahTimes.prefix(3), id: \.metadata.name) { salahView($0) } }
						HStack { ForEach(viewModel.salahTimes.dropFirst(3), id: \.metadata.name) { salahView($0) } }
					}
				} else {
					HStack { ForEach(viewModel.salahTimes, id: \.metadata.name) { salahView($0) } }
				}
		} label: {
			Text(viewModel.location)
				.font(.title)
				.placeholder(viewModel.showLoading)
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.task { await viewModel.load(location: location) }
	}

	@StateObject private var viewModel = PrayerTimesViewModel()
	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
}

extension View {
	@ViewBuilder
	func placeholder(_ showPlaceholder: Bool) -> some View {
		if showPlaceholder {
			redacted(reason: .placeholder)
		} else {
			self
		}
	}
}

struct SalahOverviewStyle: GroupBoxStyle {
	func makeBody(configuration: Configuration) -> some View {
		VStack(spacing: 8) {
			configuration.label
			configuration.content
		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.background {
			RoundedRectangle(cornerRadius: 16)
				.fill(.teal.opacity(0.4))
				.stroke(.white, lineWidth: 1)
		}
	}
}

extension GroupBoxStyle where Self == SalahOverviewStyle {
	static var salahOverview: Self { .init() }
}
