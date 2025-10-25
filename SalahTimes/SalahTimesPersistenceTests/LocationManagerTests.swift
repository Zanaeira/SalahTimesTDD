//
//  SalahTimesPersistenceTests.swift
//  SalahTimesPersistenceTests
//
//  Created by Suhayl Ahmed on 23/10/2025.
//

import XCTest
@testable import SalahTimes
import SalahTimesPersistence

final class LocationManagerTests: XCTestCase {

	func test_addLocation_throwsInvalidDataErrorOnFailureFromLoader() async {
		let (sut, loader) = makeSUT()
		var thrownError: Error?
		loader.response = .failure(.invalidData)

		do {
			try await sut.add(location: "any-invalid-location", using: anyEndpoint())
		} catch {
			thrownError = error
		}

		XCTAssertEqual(thrownError as? LoaderError, .invalidData)
	}

	func test_addLocation_throwsConnectivityErrorOnFailureFromLoader() async {
		let (sut, loader) = makeSUT()
		var thrownError: Error?
		loader.response = .failure(.connectivity)

		do {
			try await sut.add(location: "any-valid-location", using: anyEndpoint())
		} catch {
			thrownError = error
		}

		XCTAssertEqual(thrownError as? LoaderError, .connectivity)
	}

	func test_addLocation_addsLocationOnSuccess() async throws {
		let (sut, loader) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "any-valid-location", using: anyEndpoint())
		XCTAssertEqual(sut.locations.map(\.name), ["any-valid-location"])
	}

	func test_addLocation_addsEachLocationOnSuccess() async throws {
		let (sut, loader) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "any-valid-location", using: anyEndpoint())
		try await sut.add(location: "another-valid-location", using: anyEndpoint())
		XCTAssertEqual(sut.locations.map(\.name), ["any-valid-location", "another-valid-location"])
	}

	func test_addLocation_addsLocationWithTimesOnSuccess() async throws {
		let (sut, loader) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "any-valid-location", using: anyEndpoint())
		XCTAssertEqual(sut.locations, [.init(name: "any-valid-location", salahTimes: anySalahTimes())])
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

	private func makeSUT() -> (sut: LocationManager, loader: MockSalahTimesLoader) {
		let loader = MockSalahTimesLoader()
		return (LocationManager(loader: loader), loader)
	}

	private func anyEndpoint() -> Endpoint {
		AladhanAPIEndpoint.timingsByAddress("", on: .now)
	}

	private func anySalahTimes() -> SalahTimes {
		SalahTimes(timestamp: "", timezone: "", date: "", fajr: "", sunrise: "", zuhr: "", asr: "", maghrib: "", isha: "")
	}

}
