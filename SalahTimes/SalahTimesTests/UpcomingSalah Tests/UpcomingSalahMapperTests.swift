//
//  UpcomingSalahMapperTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 02/05/2025.
//

import XCTest
import SalahTimes

final class UpcomingSalahMapperTests: XCTestCase {

	func test_map_throwsErrorOnNon200HTTPResponse() throws {
		let data = makeUpcomingSalahJSON(timings: sampleTimings, timezone: sampleTimeZone)
		let sampleStatusCodes = [199, 201, 300, 400, 500]

		try sampleStatusCodes.forEach { code in
			XCTAssertThrowsError(
				try UpcomingSalahMapper.map(data, HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)

		XCTAssertThrowsError(
			try UpcomingSalahMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
		)
	}

	func test_load_deliversUpcomingSalahOn200HTTPResponseWithJSONTimes() throws {
		let upcomingSalah = UpcomingSalah(name: "Isha", time: Date(timeIntervalSince1970: 1746221040), timezone: "Europe/London")
		let data = makeUpcomingSalahJSON(timings: ["Isha": "2025-05-02T22:24:00+01:00"], timezone: ["timezone": "Europe/London"])

		let result = try UpcomingSalahMapper.map(data, HTTPURLResponse(statusCode: 200))
		XCTAssertEqual(result, upcomingSalah)
	}

	func test_load_deliversCorrectUpcomingSalahOn200HTTPResponseWithJSONTimes() throws {
		let upcomingSalah = UpcomingSalah(name: "Zuhr", time: Date(timeIntervalSince1970: 1745906160), timezone: "Asia/Dhaka")
		let data = makeUpcomingSalahJSON(timings: ["Dhuhr": "2025-04-29T11:56:00+06:00"], timezone: ["timezone": "Asia/Dhaka"])

		let result = try UpcomingSalahMapper.map(data, HTTPURLResponse(statusCode: 200))
		XCTAssertEqual(result, upcomingSalah)
	}

	// MARK: - Helpers

	private let sampleTimings = ["Fajr": "2025-04-30T03:38:00+01:00"]
	private let sampleTimeZone = ["timezone": "Europe/London"]

	private func makeUpcomingSalahJSON(timings: [String: String], timezone: [String: String]) -> Data {
		let json = [
			"data" : [
				"timings": timings,
				"meta": timezone
			]
		]
		return try! JSONSerialization.data(withJSONObject: json)
	}

}
