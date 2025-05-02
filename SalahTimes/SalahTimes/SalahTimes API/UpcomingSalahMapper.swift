//
//  UpcomingSalahMapper.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import Foundation

final class UpcomingSalahMapper {
	private static let OK_200: Int = 200

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> UpcomingSalah {
			guard response.statusCode == OK_200 else {
					throw TimesLoaderError.invalidData
			}

		guard let upcomingSalah = try JSONDecoder().decode(Root.self, from: data).data.upcomingSalah else {
			throw TimesLoaderError.invalidData
		}

		return upcomingSalah
	}

	private struct Root: Decodable {
		let data: TimingsData
	}

	private struct TimingsData: Decodable {
		let timings: Timings

		var upcomingSalah: UpcomingSalah? {
			let salahs = [timings.Fajr, timings.Dhuhr, timings.Asr, timings.Maghrib, timings.Isha]
			for (index, salahTime) in salahs.compactMap({ $0 }).enumerated() {
				guard Self.salahNames.indices.contains(index) else { continue }
				let name = Self.salahNames[index]
				guard let time = ISO8601DateFormatter().date(from: salahTime) else { continue }
				return .init(name: name, time: time)
			}

			return nil
		}

		private static let salahNames = ["Fajr", "Zuhr", "Asr", "Maghrib", "Isha"]

	}

	private struct Timings: Decodable {
		let Fajr, Dhuhr, Asr, Maghrib, Isha: String?
	}
}
