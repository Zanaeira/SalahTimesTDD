//
//  UserDefaultsLocationStore.swift
//  SalahTimesPersistence
//
//  Created by Suhayl Ahmed on 25/10/2025.
//

import Foundation
import SalahTimes

public final class UserDefaultsLocationStore: LocationStore {

	private let userDefaults: UserDefaults

	public init(suiteName: String) {
		userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
	}

	public func retrieve(_ locationName: String) throws -> Location {
		do {
			guard let data = userDefaults.data(forKey: locationName) else { throw StoreError.failedToRetrieve }
			let locationObject = try JSONDecoder().decode(CodableLocation.self, from: data)
			return locationObject.locationModel
		} catch {
			throw StoreError.failedToRetrieve
		}
	}

	public func add(_ location: Location) throws {
		do {
			let data = try JSONEncoder().encode(map(location))
			userDefaults.set(data, forKey: location.name)
		} catch {
			throw StoreError.failedToInsert
		}
	}

	private func map(_ location: Location) -> CodableLocation {
		.init(name: location.name, salahTimes: map(location.salahTimes))
	}

	private func map(_ salahTimes: SalahTimes) -> CodableSalahTimes {
		.init(
			timestamp: salahTimes.timestamp,
			timezone: salahTimes.timezone,
			date: salahTimes.date,
			fajr: salahTimes.fajr,
			sunrise: salahTimes.sunrise,
			zuhr: salahTimes.zuhr,
			asr: salahTimes.asr,
			maghrib: salahTimes.maghrib,
			isha: salahTimes.isha
		)
	}

}

fileprivate struct CodableLocation: Codable {
	let name: String
	let salahTimes: CodableSalahTimes

	var locationModel: Location {
		.init(name: name, salahTimes: map(salahTimes))
	}

	private func map(_ salahTimes: CodableSalahTimes) -> SalahTimes {
		.init(
			timestamp: salahTimes.timestamp,
			timezone: salahTimes.timezone,
			date: salahTimes.date,
			fajr: salahTimes.fajr,
			sunrise: salahTimes.sunrise,
			zuhr: salahTimes.zuhr,
			asr: salahTimes.asr,
			maghrib: salahTimes.maghrib,
			isha: salahTimes.isha
		)
	}
}

fileprivate struct CodableSalahTimes: Codable {
	let timestamp: String
	let timezone: String
	let date: String
	let fajr: String
	let sunrise: String
	let zuhr: String
	let asr: String
	let maghrib: String
	let isha: String
}
