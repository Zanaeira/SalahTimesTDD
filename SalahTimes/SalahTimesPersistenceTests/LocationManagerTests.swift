//
//  SalahTimesPersistenceTests.swift
//  SalahTimesPersistenceTests
//
//  Created by Suhayl Ahmed on 23/10/2025.
//

import XCTest
import SalahTimes
import SalahTimesPersistence

final class LocationManagerTests: XCTestCase {

	func test_addLocation_throwsErrorOnInvalidLocation() {
		let sut = LocationManager()

		XCTAssertThrowsError(try sut.add(location: "any-invalid-location"))
	}

	func test_addLocation_throwsInvalidDataErrorOnInvalidLocation() {
		let sut = LocationManager()
		var error: Error?
		XCTAssertThrowsError(try sut.add(location: "any-invalid-location")) { error = $0 }
		XCTAssertEqual(error as? LoaderError, .invalidData)
	}

}
