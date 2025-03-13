//
//  PrayerTimesScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/03/2025.
//

import SwiftUI

public struct PrayerTimesScreen: View {

	public init() {}

	public var body: some View {
		VStack {
			Text("Hello SwiftUI")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(background)
		.ignoresSafeArea()
	}

	private var background: some View {
		let purple = Color(red: 0.45, green: 0.4, blue: 1.0)
		let blue = Color.blue.opacity(0.4)
		return LinearGradient(colors: [blue, purple], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0.25, y: 1))
	}

}
