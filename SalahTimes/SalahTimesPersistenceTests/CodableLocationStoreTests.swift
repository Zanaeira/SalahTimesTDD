//
//  CodableLocationStore.swift
//  SalahTimesPersistenceTests
//
//  Created by Suhayl Ahmed on 25/10/2025.
//

import XCTest
import SalahTimes
import SalahTimesPersistence

final class CodableLocationStoreTests: XCTestCase {

	func test_insert_throwsErrorOnInsertionFailure() {
		let sut = CodableLocationStore()

		XCTAssertThrowsError(try sut.add(anyLocation()))
	}

	// MARK: Helper

	private func anyLocation() -> Location {
		.init(name: "any location", salahTimes: .init(timestamp: "", timezone: "", date: "", fajr: "", sunrise: "", zuhr: "", asr: "", maghrib: "", isha: ""))
	}

}
