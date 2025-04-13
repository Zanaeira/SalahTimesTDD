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
		VStack {
			ScrollView {
				ForEach(locations) {
					SalahTimesOverview(location: $0)
				}
			}
		}
		.padding(.top, 48)
		.onAppear { print(locations.count); print(locations) }
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

}

fileprivate struct SalahTimesOverview: View {

	let location: Location

	var body: some View {
		GroupBox {
			VStack(spacing: 16) {
				Text(viewModel.location)
					.font(.title)
					.placeholder(viewModel.showLoading)
			}
		}
		.task {
			await viewModel.load(location: location)
		}
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
