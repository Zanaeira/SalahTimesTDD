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

	func test_addLocation_throwsInvalidDataErrorOnFailureFromLoader() {
		let sut = LocationManager(loader: MockSalahTimesLoader())
		var error: Error?
		XCTAssertThrowsError(try sut.add(location: "any-invalid-location")) { error = $0 }
		XCTAssertEqual(error as? LoaderError, .invalidData)
	}

	// MARK: Helpers

	private final class MockSalahTimesLoader: TimesLoader {
		typealias Result = Swift.Result<SalahTimes, LoaderError>

		func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {}

		func load(from endpoint: Endpoint) async -> Result {
			.failure(.invalidData)
		}
	}

}
