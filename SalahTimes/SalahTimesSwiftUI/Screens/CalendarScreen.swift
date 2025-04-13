//
//  CalendarScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import SwiftUI
import SalahTimes

public struct CalendarScreen: View {

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
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

}

fileprivate struct SalahTimesOverview: View {

	let location: Location

	var body: some View {
		GroupBox {
			Text(viewModel.location)
				.font(.title)
				.placeholder(viewModel.showLoading)
		}
		.padding(.horizontal, 16)
		.groupBoxStyle(.salahOverview)
		.task { await viewModel.load(location: location) }
	}

	@StateObject private var viewModel = PrayerTimesViewModel()
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
		VStack(spacing: 16) {
			configuration.label
			configuration.content
		}
		.padding()
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
