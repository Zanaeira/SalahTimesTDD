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
		fajrAngle = location.calculationAngle.angles.flatMap {
			guard let fajrAngle = $0.fajrAngle else { return nil }
			return .init(rawValue: Int(fajrAngle))
		}
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
		.onChange(of: fajrAngle) {
			guard let fajrAngle else { return }
			let angles = location.calculationAngle.angles
			location.calculationAngle = .custom(methodSettings: .init(fajrAngle: Double(fajrAngle.rawValue), maghribAngle: angles?.maghribAngle, ishaAngle: angles?.ishaAngle))
		}
		.onChange(of: scenePhase) {
			guard scenePhase == .active else { return }
			animateMenu.toggle()
		}
		.task { await viewModel.load(location: location) }
	}

	@State private var location: Location
	@State private var fajrAngle: FajrAngle?
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

	enum FajrAngle: Int, Identifiable {
		case twelve = 12
		case fifteen = 15
		case eighteen = 18
		var id: Self { self }
	}

	private func row(_ salahTimes: [SalahTime]) -> some View {
		ForEach(salahTimes, id: \.metadata.name) { salah in
			if case .fajr = salah {
				Menu {
					Picker("Fajr angle", selection: $fajrAngle) {
						Text("12º").tag(FajrAngle.twelve)
						Text("15º").tag(FajrAngle.fifteen)
						Text("18º").tag(FajrAngle.eighteen)
					}
				} label: {
					salahView(salah)
						.symbolEffect(.bounce.byLayer, value: animateMenu)
						.tint(.white)
				}
			} else if case .asr = salah {
				Menu {
					Button("First mithl") { location.mithl = .shafii }
					Button("Second mithl") { location.mithl = .hanafi }
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

	private func salahView(_ salahTime: SalahTime) -> some View {
		VStack(spacing: 4) {
			salahTime.image
				.font(.title2)
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
