//
//  PrayerTimesScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI
internal import SalahTimes

public struct PrayerTimesScreen: View {

	public init() {}

	public var body: some View {
		VStack {
			Text(viewModel.date, format: .dateTime.weekday().day().month().year())
			Text(viewModel.label)
		}
		.task { await viewModel.load() }
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

	@StateObject private var viewModel: PrayerTimesViewModel = .init()

}
