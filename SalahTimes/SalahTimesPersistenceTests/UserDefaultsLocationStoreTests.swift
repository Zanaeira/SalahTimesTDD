//
//  UserDefaultsLocationStoreTests.swift
//  SalahTimesPersistenceTests
//
//  Created by Suhayl Ahmed on 25/10/2025.
//

import XCTest
import SalahTimes
import SalahTimesPersistence

final class UserDefaultsLocationStoreTests: XCTestCase {

	func test_insert_insertsLocationOnSuccess() throws {
		let sut = UserDefaultsLocationStore(suiteName: "test-store")
		let testLocation = Location(name: "London", salahTimes: .anySalahTimes())

		try sut.add(testLocation)
		XCTAssertEqual(try sut.retrieve("London"), testLocation)
	}

	// MARK: Helper

	private func anyLocation() -> Location {
		.init(name: "any location", salahTimes: .anySalahTimes())
	}

}

private extension SalahTimes {
	static func anySalahTimes() -> SalahTimes {
		.init(timestamp: "", timezone: "", date: "", fajr: "", sunrise: "", zuhr: "", asr: "", maghrib: "", isha: "")
	}
}
