//
//  SalahTime.swift
//  SalahTimesSwiftUI
//
//  Created by Suhayl Ahmed on 13/04/2025.
//

import SwiftUI

enum SalahTime {
	case fajr(time: String)
	case sunrise(time: String)
	case zuhr(time: String)
	case asr(time: String)
	case maghrib(time: String)
	case isha(time: String)

	struct Metadata {
		let name: String
		let imageResource: String
	}

	var time: String {
		switch self {
		case .fajr(let time), .sunrise(let time), .zuhr(let time), .asr(let time), .maghrib(let time),.isha(let time):
			time
		}
	}

	var metadata: Metadata {
		switch self {
		case .fajr: .init(name: "Fajr", imageResource: "sun.haze")
		case .sunrise: .init(name: "Sunrise", imageResource: "sunrise")
		case .zuhr: .init(name: "Zuhr", imageResource: "sun.max")
		case .asr: .init(name: "Asr", imageResource: "sun.min")
		case .maghrib: .init(name: "Maghrib", imageResource: "sunset")
		case .isha: .init(name: "Isha", imageResource: "moon.stars")
		}
	}

	var image: some View { Image(systemName: metadata.imageResource).symbolVariant(.fill) }
}
