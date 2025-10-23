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

	func test_addLocation_throwsInvalidDataErrorOnFailureFromLoader() async {
		let loader = MockSalahTimesLoader()
		let sut = LocationManager(loader: loader)
		var thrownError: Error?
		loader.response = .failure(.invalidData)

		do {
			try await sut.add(location: "any-invalid-location")
		} catch {
			thrownError = error
		}

		XCTAssertEqual(thrownError as? LoaderError, .invalidData)
	}

	func test_addLocation_throwsConnectivityErrorOnFailureFromLoader() async {
		let loader = MockSalahTimesLoader()
		let sut = LocationManager(loader: loader)
		var thrownError: Error?
		loader.response = .failure(.connectivity)

		do {
			try await sut.add(location: "any-valid-location")
		} catch {
			thrownError = error
		}

		XCTAssertEqual(thrownError as? LoaderError, .connectivity)
	}


	// MARK: Helpers

	private final class MockSalahTimesLoader: TimesLoader {
		typealias Result = Swift.Result<SalahTimes, LoaderError>

		var response: Result?

		func load(from endpoint: Endpoint, completion: @escaping (Result) -> Void) {}

		func load(from endpoint: Endpoint) async -> Result {
			response!
		}
	}

}
