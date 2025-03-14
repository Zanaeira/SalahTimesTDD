//
//  CalendarScreen.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import SwiftUI

public struct CalendarScreen: View {

	public init() {}

	public var body: some View {
		VStack {
			Label("Calendar", systemImage: "calendar")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(BackgroundView())
		.ignoresSafeArea()
	}

}
