//
//  AladhanAPINextPrayerByAddressEndpointTests.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 01/05/2025.
//

import XCTest
import SalahTimes

class AladhanAPINextPrayerByAddressEndpointTests: XCTestCase {

	func test_nextPrayerByAddress_queryItemsForAddressIncluded() {
		let address = anyAddress()
		let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(address, on: anyDate())

		let expectedQueryItems: [URLQueryItem] = [
			URLQueryItem(name: "address", value: address)
		]

		XCTAssertEqual(sut.queryItems, expectedQueryItems)
	}

	func test_nextPrayerByAddress_pathIsCorrectForDate() {
			let date = tomorrow()
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: date)
			let expectedPath = "/v1/nextPrayerByAddress/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))"

			XCTAssertEqual(sut.path, expectedPath)
	}



	// MARK: - Helpers
	private func anyAddress() -> String {
		return "Anywhere in the world"
	}

	private func anyDate() -> Date {
			return Date()
	}

	private func tomorrow() -> Date {
			let calendar = Calendar.current
			let today = Date()

			let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: today)

			return calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime)!
	}

}

private extension DateFormatter {
		static let dateFormatterForAladhanAPIRequest: DateFormatter = {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "dd-MM-yyyy"

				return dateFormatter
		}()
}
