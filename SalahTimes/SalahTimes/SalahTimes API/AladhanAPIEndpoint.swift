//
//  AladhanAPIEndpoint.swift
//  SalahTimes
//
//  Created by Suhayl Ahmed on 06/08/2021.
//

import Foundation

public struct AladhanAPIEndpoint: Endpoint {

	public let path: String
	public let queryItems: [URLQueryItem]

	public var url: URL {
		var components = URLComponents()
		components.scheme = "http"
		components.host = "api.aladhan.com"
		components.path = path
		components.queryItems = queryItems

		return components.url!
	}

	private init(path: String, queryItems: [URLQueryItem]) {
		self.path = path
		self.queryItems = queryItems
	}

	public static func timingsByAddress(_ address: String, on date: Date, iso8601DateFormat: Bool = false, madhhabForAsr: Madhhab = .hanafi, fajrIshaMethod: Method = .standard(method: .islamicSocietyOfNorthAmerica)) -> Endpoint {
		buildEndpoint(
			"timingsByAddress",
			address: address,
			on: date,
			iso8601DateFormat: iso8601DateFormat,
			madhhab: madhhabForAsr,
			fajrIsha: fajrIshaMethod
		)	}

	public static func nextPrayerByAddress(_ address: String, on date: Date, iso8601DateFormat: Bool = true, madhhab: Madhhab = .hanafi, fajrIsha: Method = .standard(method: .islamicSocietyOfNorthAmerica)) -> Endpoint {
		buildEndpoint(
			"nextPrayerByAddress",
			address: address,
			on: date,
			iso8601DateFormat: iso8601DateFormat,
			madhhab: madhhab,
			fajrIsha: fajrIsha
		)
	}

	private static func buildEndpoint(_ path: String, address: String, on date: Date, iso8601DateFormat: Bool = true, madhhab: Madhhab = .hanafi, fajrIsha: Method = .standard(method: .islamicSocietyOfNorthAmerica)) -> Endpoint {
		var queryItems = [
			URLQueryItem(name: "iso8601", value: String(iso8601DateFormat)),
			URLQueryItem(name: "address", value: address),
			URLQueryItem(name: "school", value: String(madhhab.rawValue))
		]
		fajrIsha.queryItems().forEach { queryItems.append($0) }

		let dateParameter = Calendar.current.isDateInToday(date) ? "" : "/\(dateFormattedForAPIRequest(date))"
		return AladhanAPIEndpoint(path: "/v1/\(path)\(dateParameter)", queryItems: queryItems)
	}


	// MARK: - Helpers

	private static func dateFormattedForAPIRequest(_ date: Date) -> String {
		let dateFormatter = DateFormatter.dateFormatterForAladhanAPIRequest

		return dateFormatter.string(from: date)
	}

}

private extension DateFormatter {
	static let dateFormatterForAladhanAPIRequest: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"

		return dateFormatter
	}()
}
