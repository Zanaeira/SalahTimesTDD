//
//  BackgroundView.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 14/03/2025.
//

import SwiftUI

struct BackgroundView: View {

	var body: some View {
		let purple = Color(red: 0.45, green: 0.4, blue: 1.0)
		let blue = Color.blue.opacity(0.4)
		LinearGradient(colors: [blue, purple], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0.25, y: 1))
	}

}
