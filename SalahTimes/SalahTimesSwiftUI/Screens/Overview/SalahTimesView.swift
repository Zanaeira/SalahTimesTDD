//
//  SalahTimesView.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 29/04/2025.
//

import SwiftUI

struct SalahTimesView: View {

	internal init(locationSettings: LocationSettings, viewModel: PrayerTimesViewModel) {
		self.locationSettings = locationSettings
		self.viewModel = viewModel
	}

	var body: some View {
		Group {
			if dynamicTypeSize.isAccessibilitySize {
				VStack {
					HStack { row(Array(viewModel.salahTimes.prefix(3))) }
					HStack { row(Array(viewModel.salahTimes.dropFirst(3))) }
				}
			} else {
				HStack { row(viewModel.salahTimes) }
			}
		}
		.onChange(of: locationSettings) { Task { await viewModel.load(locationSettings: locationSettings) } }
		.onChange(of: scenePhase) {
			guard scenePhase == .active else { return }
			animateMenu.toggle()
		}
	}

	@Environment(\.scenePhase) private var scenePhase
	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	@State private var locationSettings: LocationSettings
	@State private var animateMenu = false
	@ObservedObject private var viewModel: PrayerTimesViewModel

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
				.frame(minWidth: 32, minHeight: 32)
				.padding(.bottom, 2)
				.foregroundStyle(.orange)
			Text(salah.metadata.name)
			Text(viewModel.formatter.string(from: salah.time))
		}
		.fixedSize(horizontal: true, vertical: false)
	}

}
