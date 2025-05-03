//
//  UpcomingSalahMapper.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import Foundation

public final class UpcomingSalahMapper {
	private static let OK_200: Int = 200

	public enum Error: Swift.Error { case invalidData }

	public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> UpcomingSalah {
		guard response.statusCode == OK_200 else {
			throw Error.invalidData
		}

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		guard let upcomingSalah = try decoder.decode(Root.self, from: data).data.upcomingSalah else {
			throw Error.invalidData
		}

		return upcomingSalah
	}
}

private struct Root: Decodable {
	let data: TimingsData
}

private struct TimingsData: Decodable {
	let timings: Timings
	let meta: Meta

	var upcomingSalah: UpcomingSalah? {
		let salahs = [timings.Fajr, timings.Dhuhr, timings.Asr, timings.Maghrib, timings.Isha]
		for (name, salahTime) in zip(Self.salahNames, salahs) {
			if let salahTime {
				return .init(name: name, time: salahTime, timezone: meta.timezone)
			}
		}
		return nil
	}

	private static let salahNames = ["Fajr", "Zuhr", "Asr", "Maghrib", "Isha"]
}

private struct Timings: Decodable {
	let Fajr, Dhuhr, Asr, Maghrib, Isha: Date?
}

private struct Meta: Decodable {
	let timezone: String
}
