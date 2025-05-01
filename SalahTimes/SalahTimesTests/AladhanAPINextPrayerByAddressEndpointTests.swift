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
		let sut: Endpoint = AladhanAPIEndpoint.nextPrayerByAddress(address)

		let expectedQueryItems: [URLQueryItem] = [
			URLQueryItem(name: "address", value: address)
		]

		XCTAssertEqual(sut.queryItems, expectedQueryItems)
	}


	// MARK: - Helpers
	private func anyAddress() -> String {
		return "Anywhere in the world"
	}

}
