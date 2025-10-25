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

	override func setUp() {
		super.setUp()
		let userDefaults = UserDefaults(suiteName: "test-store")
		userDefaults?.removeObject(forKey: "London")
	}

	override func tearDown() {
		super.tearDown()
		let userDefaults = UserDefaults(suiteName: "test-store")
		userDefaults?.removeObject(forKey: "London")
	}

	func test_retrieve_throwsErrorOnFailure() {
		let sut = UserDefaultsLocationStore(suiteName: "test-store")
		var thrownError: Error?
		do {
			let _ = try sut.retrieve("non-existent location")
		} catch {
			thrownError = error
		}
		XCTAssertEqual(thrownError as? StoreError, .failedToRetrieve)
	}

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
