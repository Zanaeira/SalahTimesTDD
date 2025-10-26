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
		let (sut, loader, _) = makeSUT()
		var thrownError: Error?
		loader.response = .failure(.invalidData)

		do {
			try await sut.add(location: "any-invalid-location", using: anyEndpoint())
		} catch {
			thrownError = error
		}

		XCTAssertEqual(thrownError as? LoaderError, .invalidData)
	}

	func test_addLocation_doesNotAddLocationOnError() async {
		let (sut, loader, store) = makeSUT()
		loader.response = .failure(.invalidData)

		try? await sut.add(location: "any-invalid-location", using: anyEndpoint())

		XCTAssertEqual(store.locations, [])
	}


	func test_addLocation_throwsConnectivityErrorOnFailureFromLoader() async {
		let (sut, loader, _) = makeSUT()
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
		let (sut, loader, store) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "any-valid-location", using: anyEndpoint())
		XCTAssertEqual(store.locations.count, 1)
	}

	func test_addLocation_addsEachLocationOnSuccess() async throws {
		let (sut, loader, store) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "any-valid-location", using: anyEndpoint())
		try await sut.add(location: "another-valid-location", using: anyEndpoint())
		XCTAssertEqual(store.locations.count, 2)
	}

	func test_addLocation_createsLocationWithSpecifiedName() async throws {
		let (sut, loader, store) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "A location", using: anyEndpoint())
		let location = try store.retrieve("A location")
		XCTAssertEqual(location.name, "A location")
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
	private final class MockLocationStore: LocationStore {
		private(set) var locations = [Location]()

		func retrieve(_ locationName: String) throws -> Location {
			locations.first { $0.name == locationName }!
		}

		func add(_ location: Location) {
			locations.append(location)
		}
	}

	private func makeSUT() -> (sut: LocationManager, loader: MockSalahTimesLoader, store: MockLocationStore) {
		let loader = MockSalahTimesLoader()
		let store = MockLocationStore()
		return (LocationManager(loader: loader, store: store), loader, store)
	}

	private func anyEndpoint() -> Endpoint {
		AladhanAPIEndpoint.timingsByAddress("", on: .now)
	}

	private func anySalahTimes() -> SalahTimes {
		SalahTimes(timestamp: "", timezone: "", date: "", fajr: "", sunrise: "", zuhr: "", asr: "", maghrib: "", isha: "")
	}

}
