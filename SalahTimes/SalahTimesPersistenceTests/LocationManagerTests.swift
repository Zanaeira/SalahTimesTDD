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

		XCTAssertEqual(store.messages, [])
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
		XCTAssertEqual(store.messages, [.add])
	}

	func test_addLocation_addsEachLocationOnSuccess() async throws {
		let (sut, loader, store) = makeSUT()
		loader.response = .success(anySalahTimes())
		try await sut.add(location: "any-valid-location", using: anyEndpoint())
		try await sut.add(location: "another-valid-location", using: anyEndpoint())
		XCTAssertEqual(store.messages, [.add, .add])
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
		enum Message {
			case add
			case retrieve
		}

		private(set) var messages = [Message]()

		func retrieve(_ locationName: String) throws -> Location {
			messages.append(.retrieve)
			throw NSError(domain: "", code: 0)
		}

		func add(_ location: Location) {
			messages.append(.add)
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
