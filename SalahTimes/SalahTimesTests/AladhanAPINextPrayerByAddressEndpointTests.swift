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

		XCTAssertTrue(sut.queryItems.contains(expectedQueryItems[0]))
	}

	func test_nextPrayerByAddress_pathIsCorrectForDate() {
			let date = tomorrow()
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: date)
			let expectedPath = "/v1/nextPrayerByAddress/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))"

			XCTAssertEqual(sut.path, expectedPath)
	}

	func test_nextPrayerByAddress_dateFormatIsIso8601ByDefault() {
			let date = tomorrow()
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: date)
			let expectedQueryItem = URLQueryItem(name: "iso8601", value: "true")

			XCTAssertTrue(sut.queryItems.contains(expectedQueryItem))
	}

	func test_nextPrayerByAddress_dateFormatQueryParameterIsIncluded() {
			let date = tomorrow()
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: date, iso8601DateFormat: false)
			let expectedQueryItem = URLQueryItem(name: "iso8601", value: "false")

			XCTAssertTrue(sut.queryItems.contains(expectedQueryItem))
	}

	func test_nextPrayerByAddress_queryItemsIncludesSchoolForAsrTimeCalculation() {
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: anyDate(), madhhab: .shafii)
			let schoolForAsrTimeQueryItem = URLQueryItem(name: "school", value: "0")

			XCTAssertTrue(sut.queryItems.contains(schoolForAsrTimeQueryItem))
	}

	func test_nextPrayerByAddress_respectsRequestedMadhabForAsr() {
		let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: anyDate(), madhhab: .hanafi)
		let schoolForAsrTimeQueryItem = URLQueryItem(name: "school", value: "1")

		XCTAssertTrue(sut.queryItems.contains(schoolForAsrTimeQueryItem))
	}

}
