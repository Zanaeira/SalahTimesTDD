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
			Text(locations.count, format: .number)
			Text(locations.map(\.location).joined(separator: ", "))
			ForEach(locations) { location in
				Text(location.location)
				Text(location.calculationAngle.toString())
			}
		}
		.onAppear { print(locations.count); print(locations) }
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

}

extension AladhanAPIEndpoint.Method {
	func toString() -> String {
		switch self {
		case .standard(let method): "\(method)"
		case .custom(let methodSettings): "Fajr Angle: \(methodSettings.fajrAngle ?? 0)\nIsha Angle: \(methodSettings.ishaAngle ?? 0)"
		}
	}
}
