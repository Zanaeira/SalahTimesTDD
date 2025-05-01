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

	func test_nextPrayerByAddress_queryItemsIncludesCalculationMethodForFajrAndIsha() {
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: anyDate())
			let calculationMethodQueryItem = URLQueryItem(name: "method", value: "2")

			XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItem))
	}

	func test_nextPrayerByAddress_calculationMethodForFajrAndIshaCanBeChanged() {
		let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: anyDate(), fajrIsha: .standard(method: .muslimWorldLeague))
			let calculationMethodQueryItem = URLQueryItem(name: "method", value: "3")

			XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItem))
	}

	func test_nextPrayerByAddress_allowsCustomCalculationMethodForFajrAndIsha() {
			let methodSettings = AladhanAPIEndpoint.MethodSettings(fajrAngle: 18.5, maghribAngle: nil, ishaAngle: 17.5)
			let method = AladhanAPIEndpoint.Method.custom(methodSettings: methodSettings)
			let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(anyAddress(), on: anyDate(), fajrIsha: method)
			let calculationMethodQueryItems = [URLQueryItem(name: "method", value: "99"),
																				 URLQueryItem(name: "methodSettings", value: "18.5,null,17.5")]

			XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[0]))
			XCTAssertTrue(sut.queryItems.contains(calculationMethodQueryItems[1]))
	}

	func test_nextPrayerByAddress_urlContainsHostSchemePathAndAllQueryItemsSpecified() {
		let address = "London"
		let date = tomorrow()
		let madhhab = AladhanAPIEndpoint.Madhhab.hanafi
		let method = AladhanAPIEndpoint.Method.standard(method: .muslimWorldLeague)

		let expectedURL = URL(string: "http://api.aladhan.com/v1/nextPrayerByAddress/\(DateFormatter.dateFormatterForAladhanAPIRequest.string(from: date))?iso8601=true&address=\(address)&school=1&method=3")!

		let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(address, on: date, madhhab: madhhab, fajrIsha: method)

		XCTAssertEqual(sut.url, expectedURL)
	}

}
