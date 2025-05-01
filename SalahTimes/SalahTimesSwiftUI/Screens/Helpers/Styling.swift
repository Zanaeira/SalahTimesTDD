//
//  Styling.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 26/04/2025.
//

import SwiftUI

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
				.fill(.teal.opacity(0.4).gradient)
				.stroke(.white, lineWidth: 1)
		}
	}
}

extension GroupBoxStyle where Self == SalahOverviewStyle {
	static var salahOverview: Self { .init() }
}
